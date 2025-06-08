class MessagesRespondedYesterdayWorker
  include Sidekiq::Worker
  include Task::Mapping

  # ADMIN_GROUP = "120363403470995044@g.us"
  ADMIN_GROUP = "120363418474521633@g.us"

  def perform
    Waapi.gateway.send_message(message, ADMIN_GROUP)
  end

  private

  def messages_by_person
     @messages_by_person ||= Message
      .where(created_at: Time.zone.yesterday.all_day, sender_role: "host")
      .group(:sender_full_name)
      .order(Arel.sql("COUNT(*) DESC"))
      .count
  end

  def messages_by_person_text
    messages_by_person.map.with_index do |(name, count), index|
      "#{index+1}. #{name} - #{count} mensajes 🎉🎉"
    end.join("\n")
  end

  def winner
    messages_by_person.first[0]
  end

  def message
    <<~MESSAGE
      Buenos dias equipo ☕

      *Mensajes respondidos ayer por persona:*
      #{messages_by_person_text}

      Gracias a todos que respondieron!
    MESSAGE
  end
end
