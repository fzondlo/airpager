class Task
  include Task::Mapping

  def sync_all_tasks
    sync_cleaning_tasks
    sync_reservation_tasks
  end

  def sync_cleaning_tasks
    SyncTasks.new(
      hospitable_reservations,
      update_actions_for(clean_tasks),
      clean_tasks,
      :limpiezas
    ).sync
  end

  def sync_reservation_tasks
    SyncTasks.new(
      hospitable_reservations,
      update_actions_for(res_tasks),
      res_tasks,
      :reservas
    ).sync
  end

  def clean_tasks
    Clickup.gateway.find_tasks(:limpiezas)
  end

  def res_tasks
    Clickup.gateway.find_tasks(:reservas)
  end

  def next_task_for_cleaner(cleaner_cf_id)
    today_in_ms = (Time.new(Time.now.year, Time.now.month, Time.now.day, 0, 0, 0).to_i * 1000)
    custom_fields_filter = [
      {
        field_id: CUSTOM_FIELD_IDS[:limpiadora],
        operator: "=",
        value: cleaner_cf_id
      }
    ].to_json
    params = {
      custom_fields: custom_fields_filter,
      due_date_gt: today_in_ms,
      order_by: "due_date",
      statuses: ["ACTIVO"],
      reverse: true
    }
    Clickup.gateway.find_tasks(:limpiezas, params)
  end

  private

  def update_actions_for(tasks)
    UpdateAction.new(
      hospitable_reservations,
      tasks
    ).actions_for_reservation_ids
  end

  def hospitable_reservations
    @hospitable_reservations ||= Reservation.all
  end
end
