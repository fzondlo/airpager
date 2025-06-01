class ClickupWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  include Task::Mapping

  def create
    if cleaner_update? && assigned_cleaner
      AssignedCleanerWorker.perform_async(task_id, assigned_cleaner)
    end
  end

  private

  def payload
    @payload ||= JSON.parse(request.body.read).with_indifferent_access
  end

  def task_id
    payload[:task_id]
  end

  def cleaner_update?
    payload[:history_items][0][:custom_field][:id] == CUSTOM_FIELD_IDS[:limpiadora]
  end

  def assigned_cleaner
    CLEANING_STAFF.find do |staff|
      staff[:custom_field_id] == payload[:history_items][0][:after]
    end
  end

end

