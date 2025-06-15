class HospitableWebhooksController
  class MessageEscalationPath
    include Task::Mapping

    attr_reader :urgency, :message, :incident

    def initialize(urgency_level, message, incident)
      @urgency = urgency_level
      @message = message
      @incident = incident
    end

    def escalate
      case @urgency
      when :NO_RESPONSE_REQUIRED
        log_to_wappi("No response required for message from #{@message[:sender_full_name]}")
      when :P1
        escalate_p1
      when :P2
        escalate_p2
      when :P3
        escalate_p3
      else
        raise "Unknown urgency level: #{@urgency}"
      end
    end

    private

    def escalate_p1
      alert_person_on_call
      (1..4).each do |i|
        AlertPersonOnCallWorker.perform_in(i.minutes, incident.id, message.id)
      end
      (5..20).each do |i|
        AlertTeamWorker.perform_in(i.minutes, incident.id, message.id)
      end
      NotifyTeamOfIncidentWorker.perform_in(20.minutes, incident.id)
    end

    def escalate_p2
      alert_person_on_call
      [ 2, 4, 6, 8 ].each do |minutes|
        AlertPersonOnCallWorker.perform_in(minutes.minutes, incident.id, message.id)
      end
      (10..20).each do |i|
        AlertTeamWorker.perform_in(i.minutes, incident.id, message.id)
      end
      NotifyTeamOfIncidentWorker.perform_in(20.minutes, incident.id)
    end

    def escalate_p3
      if after_hours?
        after_hours_response
        # TODO: Call worker witth message id and urgency level for 8:30am tomorrow
      else
        alert_person_on_call
      end
    end

    # def pager
    #   NotifyTeamOfIncidentWorker.perform_in(15.minutes, incident.id)
    # end

    def after_hours_response
      AfterHoursAutoResponderWorker.perform_in(2.minutes, message.reservation_id)
      log_to_wappi("After hours response sent to #{message.sender_full_name}")
    end

    def alert_person_on_call
      alert = "Tienes un mensaje pendiente de AirBnB con Prioridad #{@urgency} de #{message.sender_full_name}"
      Waapi.gateway.send_message(alert, person_on_call)
      log_to_wappi("#{alert} - sent to #{STAFF_ON_CALL}")
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

    def schedule_for_830
      now = Time.zone.now
      scheduled_time = now.change(hour: 8, min: 0, sec: 0)

      # If it's already past 8am today, schedule for tomorrow
      scheduled_time += 1.day if now >= scheduled_time
    end
  end
end
