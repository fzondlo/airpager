class IncidentsController < ApplicationController
  def index
    analytics_resolved_by = params[:analytics_resolved_by]

    time_scope = Incident.where.not(resolved_at: nil)
    time_scope = time_scope.where(resolved_by: analytics_resolved_by) if analytics_resolved_by.present?

    @average_resolved_time = time_scope.average("EXTRACT(EPOCH FROM resolved_at - created_at)")

    @resolved_by_options = Incident.where.not(resolved_by: nil).distinct.pluck(:resolved_by)

    @incidents = IncidentViewModel.wrap(Incident.order(created_at: :desc).all)
  end

  def show
    @incident = IncidentViewModel.wrap(Incident.find(params[:id]))
  end
end
