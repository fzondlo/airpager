class UpdateResolvedByFromIncidents < ActiveRecord::Migration[8.0]
  def change
    # Clean the resolved_by field, remove email part
    Incident.resolved.each do |incident|
      cleaned_name = incident.resolved_by.split('<').first.strip

      incident.update(resolved_by: cleaned_name)
    end
  end
end
