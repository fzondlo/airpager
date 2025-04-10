class IncidentsController < ApplicationController
  def index
    #Incident.create(kind: 'pending_reply', source_details: { platform: 'airbnb', conversation_id: '38383' })
    @incidents = IncidentViewModel.wrap(Incident.order(created_at: :desc).all)
  end
end
