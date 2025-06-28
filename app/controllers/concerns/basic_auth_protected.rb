module BasicAuthProtected
  extend ActiveSupport::Concern

  included do
    if Rails.env.production?
      http_basic_authenticate_with name: "airpager", password: "aircontrol"
    end
  end
end
