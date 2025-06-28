class AutoRepliesController < ApplicationController
  include BasicAuthProtected

  before_action :set_properties, only: [:new, :edit]
  before_action :set_auto_reply, only: [:show, :edit, :update, :destroy]

  def index
    @auto_replies = AutoReply.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @properties = Property.order(:slug)
    @auto_reply = AutoReply.new
  end

  def edit
  end

  def create
    @auto_reply = AutoReply.new(auto_reply_params)

    if @auto_reply.save
      redirect_to auto_replies_path, notice: "Auto reply was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @auto_reply.update(auto_reply_params)
      redirect_to auto_replies_path, notice: "Auto reply was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @auto_reply.destroy
    redirect_to auto_replies_path, notice: "Auto reply was successfully deleted."
  end

  private

  def set_auto_reply
    @auto_reply = AutoReply.find(params[:id])
  end

  def set_properties
    @properties = Property.all
  end

  def auto_reply_params
    params.require(:auto_reply).permit(:trigger, :reply, property_ids: [])
  end
end
