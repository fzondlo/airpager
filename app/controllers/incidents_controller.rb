class IncidentsController < ApplicationController
  include BasicAuthProtected

  def index
    @incident_query = IncidentQuery.new(search_params)
    @analytics_query = IncidentAnalyticsQuery.new(search_params)

    if @analytics_query.from_today?
      @analytics_compare = IncidentAnalyticsCompare.new(
        current: @analytics_query,
        to: IncidentAnalyticsQuery.new(search_params.merge({ period: "yesterday" }))
      )
    end

    @incidents = IncidentViewModel.wrap(@incident_query.scoped)

    @resolved_by_options = Incident.resolved.select(:resolved_by).distinct.pluck(:resolved_by).sort
    @urgency_level_options = ["P0", "P1", "P2", "P3"]
  end

  def show
    @incident = IncidentViewModel.wrap(Incident.find(params[:id]))
  end

  private

  def search_params
    @search_params ||= params.fetch(:search, {}).permit(:period, :resolved_by, :start_date, :end_date, :urgency_level)
  end
end
