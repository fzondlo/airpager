class HospitableWebhooksController
  class MessageEscalationPath
    include Task::Mapping

    attr_reader :urgency_level, :message, :incident

    def initialize(urgency_level, message, incident)
      @urgency_level = urgency_level
      @message = message
      @incident = incident
    end

    def escalate
      case urgency_level
      when :P0
        incident.update(urgency_level: 'P0')
        log_to_wappi("No response required for message from #{message[:sender_full_name]}: #{message[:content]}")
      when :P1
        incident.update(urgency_level: 'P1')
        escalate_p1
      when :P2
        incident.update(urgency_level: 'P2')
        escalate_p2
      when :P3
        incident.update(urgency_level: 'P3')
        escalate_p3
      else
        raise "Unknown urgency level: #{urgency_level}"
      end
    end

    private

    def escalate_p1
      alert_person_on_call
      (1..4).each do |i|
        AlertPersonOnCallWorker.perform_in(i.minutes, incident.id, message.id, urgency_level)
      end
      (5..20).each do |i|
        AlertTeamWorker.perform_in(i.minutes, incident.id, message.id, urgency_level)
      end
      NotifyTeamOfIncidentWorker.perform_in(20.minutes, incident.id)
    end

    def escalate_p2
      alert_person_on_call
      [ 2, 4, 6, 8 ].each do |minutes|
        AlertPersonOnCallWorker.perform_in(minutes.minutes, incident.id, message.id, urgency_level)
      end
      (10..20).each do |i|
        AlertTeamWorker.perform_in(i.minutes, incident.id, message.id, urgency_level)
      end
      NotifyTeamOfIncidentWorker.perform_in(20.minutes, incident.id)
    end

    def escalate_p3
      # TODO: Create after hours response that guests can click on to escalate
      if after_hours?

        if has_reservation?
          send_escalation_link_to_guest
        end

        AlertPersonOnCallWorker.perform_at(next_830, incident.id, message.id, urgency_level)
        [ 10, 20, 30 ].each do |minutes|
          scheduled_time = next_830 + minutes.minutes
          AlertPersonOnCallWorker.perform_at(scheduled_time, incident.id, message.id, urgency_level)
        end
        [ 40, 45 ].each do |minutes|
          scheduled_time = next_830 + minutes.minutes
          AlertTeamWorker.perform_at(scheduled_time, incident.id, message.id, urgency_level)
        end
        NotifyTeamOfIncidentWorker.perform_at(next_830 + 45.minutes, incident.id)
      else
        alert_person_on_call
        [ 10, 20, 30 ].each do |minutes|
          AlertPersonOnCallWorker.perform_in(minutes.minutes, incident.id, message.id, urgency_level)
        end
        [ 40, 45 ].each do |minutes|
          AlertTeamWorker.perform_in(minutes.minutes, incident.id, message.id, urgency_level)
        end
        NotifyTeamOfIncidentWorker.perform_in(45.minutes, incident.id)
      end
    end

    # def after_hours_response
    #   AfterHoursAutoResponderWorker.perform_in(2.minutes, message.reservation_id)
    #   log_to_wappi("After hours response sent to #{message.sender_full_name}")
    # end

    def alert_person_on_call
      alert = "Tienes un mensaje pendiente de AirBnB con Prioridad #{urgency_level} de #{message.sender_full_name}"
      Waapi.gateway.send_message(alert, person_on_call)
      log_to_wappi("#{alert} - sent to #{STAFF_ON_CALL} for #{message[:sender_full_name]}: #{message[:content]}")
    end

    def send_escalation_link_to_guest
      incident_escalation = IncidentEscalation.create(
        incident: incident,
        expires_at: next_830
      )

      debug_details = <<~TEXT
        ---`

        Debug details

        Incident url: #{Rails.application.routes.url_helpers.incident_url(incident.id, host: "airpager-d950d85687e0.herokuapp.com")}
      TEXT

      escalation_message = <<~TEXT
        Hi there, thanks for reaching out!

        You’ve caught us outside of our usual hours, but no worries — we will be back at 8:30 am.

        We appreciate your patience and look forward to helping you soon.

        If this is an urgent request click this link: #{Rails.application.routes.url_helpers.incident_escalation_url("the-token", host: "airpager-d950d85687e0.herokuapp.com")}

        #{debug_details}
      TEXT

      # Just logging for the time being
      log_to_wappi(escalation_message)
    end

    def log_to_wappi(alert)
      Waapi.gateway.send_message(alert, LOGGING_WA_GROUP)
    end

    def person_on_call
      STAFF_PHONE_NUMBERS[STAFF_ON_CALL]
    end

    def after_hours?
      current_hour = Time.zone.now.hour
      !current_hour.between?(8, 21)
    end

    def has_reservation?
      message.reservation_id.present?
    end

    # I say next because this is used to schedule a job for the next morning at 8:30am
    def next_830
      now = Time.zone.now
      scheduled_time = now.change(hour: 8, min: 0, sec: 0)

      # If it's already past 8am today, schedule for tomorrow
      scheduled_time += 1.day if now >= scheduled_time
    end
  end
end
