class IncidentsController < ApplicationController
  def index
    @analytics_query = IncidentAnalyticsQuery.new(analytics_params)

    if @analytics_query.from_today?
      @analytics_compare = IncidentAnalyticsCompare.new(
        current: @analytics_query,
        to: IncidentAnalyticsQuery.new(analytics_params.merge({ period: "yesterday" }))
      )
    end

    @resolved_by_options = Incident.resolved.select(:resolved_by).distinct.pluck(:resolved_by)

    @incidents = IncidentViewModel.wrap(Incident.order(created_at: :desc).all)
  end

  def show
    @incident = IncidentViewModel.wrap(Incident.find(params[:id]))
  end

  private

  def analytics_params
    params.fetch(:analytics, {}).permit(:period, :resolved_by, :start_date, :end_date)
  end
end
