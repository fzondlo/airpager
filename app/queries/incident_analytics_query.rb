class IncidentAnalyticsQuery
  attr_reader :period, :urgency_level, :resolved_by, :start_date, :end_date

  def initialize(params = {})
    @resolved_by = params[:resolved_by]
    @urgency_level = params[:urgency_level]
    @period = params[:period]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def scoped
    scope = Incident.resolved
    scope = filter_by_resolved_by(scope)
    scope = filter_by_period(scope)
    scope = filter_by_urgency_level(scope)
    scope
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

  def from_today?
    period.nil? || period == "today"
  end

  private

  def filter_by_resolved_by(scope)
    return scope unless resolved_by.present?

    scope.where(resolved_by: resolved_by)
  end

  def filter_by_urgency_level(scope)
    return scope unless urgency_level.present?

    scope.where(urgency_level: urgency_level)
  end

  def filter_by_period(scope)
    case period
    when "today"
      scope.where(resolved_at: period_today)
    when "yesterday"
      scope.where(resolved_at: period_yesterday)
    when "this_week"
      scope.where(resolved_at: period_this_week)
    when "this_month"
      scope.where(resolved_at: period_this_month)
    when "all_time"
      scope
    when "custom"
      filter_by_custom_period(scope)
    else
      # By default, filter by Today
      scope.where(resolved_at: period_today)
    end
  end

  def filter_by_custom_period(scope)
    if start_date.present? && !end_date.present?
      return scope.where(resolved_at: start_date.to_date.all_day)
    end

    if start_date.present? && end_date.present?
      return scope.where(resolved_at: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day)
    end

    scope
  end

  def period_today
    Time.zone.today.all_day
  end

  def period_yesterday
    Time.zone.yesterday.all_day
  end

  def period_this_week
    1.week.ago.beginning_of_day..Time.zone.now
  end

  def period_this_month
    1.month.ago.beginning_of_day..Time.zone.now
  end
end
