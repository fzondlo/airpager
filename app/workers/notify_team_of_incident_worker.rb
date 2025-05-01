class NotifyTeamOfIncidentWorker
  include Sidekiq::Worker

  def perform(incident_id)
    incident = Incident.find_by(id: incident_id)

    unless incident.present?
      Sidekiq.logger.warn "Incident #{incident_id} not found. Skipping."
      return
    end

    if incident.resolved?
      Sidekiq.logger.warn "Incident #{incident_id} is resolved. Don't need to notify team. Skipping."
      return
    end

    Allquiet.gateway.create_incident

    incident.alert!
  end
end
