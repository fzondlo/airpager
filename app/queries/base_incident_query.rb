class BaseIncidentQuery
  attr_reader :period, :urgency_level, :resolved_by, :start_date, :end_date

  def initialize(params = {})
    @resolved_by = params[:resolved_by]
    @urgency_level = params[:urgency_level]
    @period = params[:period]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def from_today?
    period.nil? || period == "today"
  end

  def scoped
    raise NotImplementedError, "Subclasses must implement `scoped`"
  end

  def apply_filters(scope)
    scope = filter_by_resolved_by(scope)
    scope = filter_by_period(scope)
    scope = filter_by_urgency_level(scope)
    scope
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
    when "today"      then scope.where(created_at: period_today)
    when "yesterday"  then scope.where(created_at: period_yesterday)
    when "this_week"  then scope.where(created_at: period_this_week)
    when "this_month" then scope.where(created_at: period_this_month)
    when "custom"     then filter_by_custom_period(scope)
    when "all_time"   then scope
    else
      scope.where(created_at: period_today)
    end
  end

  def filter_by_custom_period(scope)
    if start_date.present? && !end_date.present?
      return scope.where(created_at: start_date.to_date.all_day)
    end

    if start_date.present? && end_date.present?
      return scope.where(created_at: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day)
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
