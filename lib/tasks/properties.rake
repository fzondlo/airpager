namespace :properties do
  desc "Sync Task::Mapping::PROPERTIES into Property records"
  task sync_from_mapping: :environment do
    Task::Mapping::PROPERTIES.each do |prop|
      attrs = {
        name: prop[:name],
        slug: prop[:name].parameterize,
        address: prop[:address],
        google_maps_url: prop[:google_maps],
        hospitable_id: prop[:hospitable_id]
      }

      property = Property.find_or_initialize_by(clickup_custom_field_id: prop[:custom_field_id])
      property.assign_attributes(attrs)

      if property.save
        puts "✅ Synced: #{property.name}"
      else
        puts "❌ Failed: #{property.name} – #{property.errors.full_messages.join(', ')}"
      end
    end
  end

  desc "Sync Hospitable property information into the hospitable_metadata field on Property records"
  task sync_hospitable_metadata: :environment do
    response = Hospitable.gateway.find_properties

    unless response.success?
      puts "❌ Failed: Unable to retrieve properties from hospitable"
      next
    end

    hospitable_properties = response.properties

    hospitable_properties.each do |hospitable_property|
      property = Property.find_by(hospitable_id: hospitable_property["id"])

      unless property.present?
        puts "⚠️ Skipping: Property with hospitable_id #{hospitable_property["id"]} not found"
        next
      end

      property.hospitable_metadata = hospitable_property

      if property.save
        puts "✅ Synced: #{property.name}"
      else
        puts "❌ Failed: #{property.name} – #{property.errors.full_messages.join(', ')}"
      end
    end
  end
end
