class IncidentQuery < BaseIncidentQuery
  def scoped
    scope = Incident.all

    apply_filters(scope).order(created_at: :desc)
  end
end
