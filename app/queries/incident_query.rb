class IncidentQuery < BaseIncidentQuery
  def scoped
    scope = Incident.all

    apply_filters(scope)
  end
end
