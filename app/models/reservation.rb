class Reservation
  def self.all
    Hospitable.gateway.find_reservations(property_ids)
  end

  def self.property_ids
    Hospitable.gateway.find_properties.properties.pluck("id")
  end
end
