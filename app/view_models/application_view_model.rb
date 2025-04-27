class ApplicationViewModel
  include Rails.application.routes.url_helpers
  include ActionView::Helpers
  include ActionView::Context

  attr_reader :model, :options

  def self.wrap(model, options = {})
    if model.is_a?(Enumerable)
      model.map { |m| new(m, options) }
    else
      new(model, options)
    end
  end

  def initialize(model = nil, options = {})
    @model = model
    @options = if options.respond_to?(:to_unsafe_h)
                 options.to_unsafe_h.with_indifferent_access
    else
                 options.to_h.with_indifferent_access
    end
  end

  def method_missing(method, *args, &block)
    super unless model
    super unless model.respond_to?(method)

    # Define a method so the next call is faster
    self.class.send(:define_method, method) do |*args, &blok|
      model.send(method, *args, &blok)
    end

    send(method, *args, &block)

  rescue NoMethodError => no_method_error
    super if no_method_error.name == method
    raise no_method_error
  end

  def respond_to?(*args)
    super || (model && model.respond_to?(*args))
  end

  def present?
    model.present?
  end

  def blank?
    model.blank?
  end

  def nil?
    model.nil?
  end
end
