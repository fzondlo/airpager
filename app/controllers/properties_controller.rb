class PropertiesController < ApplicationController
  include BasicAuthProtected

  before_action :set_missing_hospitable_properties, only: [ :index ]

  def index
    @properties = Property.all
  end

  def show
    @property = Property.find(params[:id])
  end

  private

  def set_missing_hospitable_properties
    @missing_hospitable_properties = Rails.cache.fetch("properties/missing_hospitable_properties", expires_in: 5.minutes) do
      response = Hospitable.gateway.find_properties

      unless response.success?
        []
      else
        response.properties.reject do |hospitable_property|
          Property.find_by(hospitable_id: hospitable_property["id"]).present?
        end
      end
    end
  end
end
