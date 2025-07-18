class MessagesRespondedYesterdayWorker
  include Sidekiq::Worker
  include SystemConfig

  ADMIN_GROUP = "120363403470995044@g.us"

  def perform
    Waapi.gateway.send_message(message, ADMIN_GROUP)
  end

  private

  def incident_by_person
     @incident_by_person ||= Incident
      .where(created_at: Time.zone.yesterday.all_day)
      .group(:resolved_by)
      .order(Arel.sql("COUNT(*) DESC"))
      .count
  end

  def incident_by_person_text
    incident_by_person.map.with_index do |(name, count), index|
      "#{index+1}. #{name} - #{count} incidentes 🎉🎉"
    end.join("\n")
  end

  def message
    <<~MESSAGE
      Buenos dias equipo ☕

      *Incidentes respondidos ayer por persona:*
      #{incident_by_person_text}

      Gracias a todos que respondieron!
    MESSAGE
  end
end
