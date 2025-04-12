class IncidentAnalyticsCompare
  attr_reader :current, :to

  def initialize(current:, to:)
    @current = current
    @to = to
  end

  def average_resolution_time
    Result.new(
      current.average_resolution_time,
      to.average_resolution_time,
      better_when_lower: true
    )
  end

  def total_incidents_resolved
    Result.new(
      current.total_incidents_resolved,
      to.total_incidents_resolved,
      better_when_lower: false
    )
  end
end

class IncidentAnalyticsCompare::Result
  attr_reader :current, :previous, :better_when_lower

  def initialize(current, previous, better_when_lower:)
    @current = current
    @previous = previous
    @better_when_lower = better_when_lower
  end

  def comparable?
    !current.nil? && !previous.nil?
  end

  def difference
    return unless comparable?

    current - previous
  end

  def percentage_change
    return unless comparable?

    if previous.zero?
       return current.zero? ? 0 : Float::INFINITY
     end

    ((difference / previous.to_f) * 100).round(2)
  end

  def percentage_change_display
    if percentage_change.nil? || percentage_change.infinite?
      return "∞ %"
    end

    "#{percentage_change}%"
  end

  def better?
    return false unless comparable?
    return false if same?

    better_when_lower ? (current < previous) : (current > previous)
  end

  def worst?
    comparable? && !better? && !same?
  end

  def same?
    comparable? && (current == previous)
  end

  def arrow
    if !comparable? || same?
      return "→"
    end

    difference.negative? ? "↓" : "↑"
  end

  def difference_class
    if !comparable? || same?
      return "text-gray-500"
    end

    better? ? "text-green-600" : "text-red-600"
  end
end
