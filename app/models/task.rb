class Task

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
