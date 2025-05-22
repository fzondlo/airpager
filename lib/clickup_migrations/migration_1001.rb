module ClickupMigrations
  class Migration1001 < Base

    DESCRIPTION = <<~DESCRIPTION
        This will update the following boards: Limpieza and Reservas

        It will find any task that has a due_date_time or a start_date_time
        that is set to a unix time stamp, and update them to TRUE
      DESCRIPTION

    private

    def migration_up
      binding.pry
    end
  end
end
