class AutoReplyViewModel < ApplicationViewModel
  def property_names_display
    model.properties.map(&:name).sort.join(", ")
  end
end
