class IncidentsController < ApplicationController
  def index
    @average_resolution_time = analytics_query.average_resolution_time

    @resolved_by_options = Incident.resolved.select(:resolved_by).distinct.pluck(:resolved_by)

    @incidents = IncidentViewModel.wrap(Incident.order(created_at: :desc).all)
  end

  def show
    @incident = IncidentViewModel.wrap(Incident.find(params[:id]))
  end

  private

  def analytics_query
    IncidentAnalyticsQuery.new(analytics_params)
  end

  def analytics_params
    params.fetch(:analytics, {}).permit(:period, :resolved_by, :start_date, :end_date)
  end
end
