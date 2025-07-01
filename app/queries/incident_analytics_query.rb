class IncidentAnalyticsQuery < BaseIncidentQuery
  def scoped
    scope = Incident.resolved

    apply_filters(scope)
  end

  def average_resolution_time
    return @average_resolution_time if defined?(@average_resolution_time)

    scope = scoped

    # After April 29, 2025
    scope = scope.where("created_at >= ?", Time.zone.local(2025, 4, 29))

    @average_resolution_time = scope.average("EXTRACT(EPOCH FROM resolved_at - created_at)")
  end

  def total_incidents_resolved
    @total_incidents_resolved ||= scoped.count
  end
end
