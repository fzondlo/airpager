class AutoReplyViewModel < ApplicationViewModel
  def property_names_display
    if model.properties.any?
      model.properties.map(&:name).sort.join(", ")
    else
      "No properties selected"
    end
  end
end
