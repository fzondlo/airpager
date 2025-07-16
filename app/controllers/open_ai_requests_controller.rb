class OpenAiRequestsController < ApplicationController
  include BasicAuthProtected

  def index
    @requests = OpenAiRequest.order(created_at: :desc).all
  end

  def show
    @request = OpenAiRequest.find(params[:id])
  end
end
