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

  def cleanings_tomorrow
    tomorrow = Date.today + 1
    tomorrow_start = Time.new(tomorrow.year, tomorrow.month, tomorrow.day, 0, 0, 0)
    tomorrow_end = Time.new(tomorrow.year, tomorrow.month, tomorrow.day, 23, 59, 59)
    params = {
      due_date_gt: tomorrow_start.to_i * 1000,
      due_date_lt: tomorrow_end.to_i * 1000,
      order_by: "start_date",
      statuses: [ "ACTIVO" ],
      reverse: true
    }
    Clickup.gateway.find_tasks(:limpiezas, params)
  end

  def cleanings_today
    today = Date.today
    today_start = Time.new(today.year, today.month, today.day, 0, 0, 0)
    today_end = Time.new(today.year, today.month, today.day, 23, 59, 59)
    params = {
      due_date_gt: today_start.to_i * 1000,
      due_date_lt: today_end.to_i * 1000,
      order_by: "start_date",
      statuses: [ "ACTIVO" ],
      reverse: true
    }
    Clickup.gateway.find_tasks(:limpiezas, params)
  end

  def next_task_for_cleaner(cleaner_cf_id)
    now_in_ms = (Time.now.to_f * 1000).to_i
    custom_fields_filter = [
      {
        field_id: CUSTOM_FIELD_IDS[:limpiadora],
        operator: "=",
        value: cleaner_cf_id
      }
    ].to_json
    params = {
      custom_fields: custom_fields_filter,
      due_date_gt: now_in_ms,
      order_by: "start_date",
      statuses: [ "ACTIVO" ],
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
