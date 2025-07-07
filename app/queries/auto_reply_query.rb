class AutoReplyQuery
  attr_reader :property_id

  def initialize(params = {})
    @property_id = params[:property_id]
  end

  def scoped
    scope = AutoReply.all

    if property_id.present?
      scope = scope.joins(:properties).where(properties: { id: property_id }).distinct
    end

    scope.order(created_at: :desc)
  end
end
