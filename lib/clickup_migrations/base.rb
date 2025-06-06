module ClickupMigrations
  class Base
    def up
      force_confirmation
      puts "Running migration up ##{migration_number}..."
      migration_up
      puts "Migration completed successfull!"
    end

    def down
      force_confirmation
      puts "Running migration down ##{migration_number}..."
      migration_down
    end

    private

    def migration_number
      self.class.name.gsub(/\D/, "")
    end

    def migration_down
      raise NotImplementedError, "#{self.class} must implement #call"
    end

    def migration_up
      raise NotImplementedError, "#{self.class} must implement #call"
    end

    def force_confirmation
      puts <<~WARNING
        \n\nWARNING DESTRUCTIVE ACTION

        Description: #{self.class::DESCRIPTION}
        Please type \"CONTINUE\" in order to continue\n
      WARNING

      if STDIN.gets.to_s.strip.downcase != "continue"
        puts "Exiting!"
        exit 1
      end
    end
  end
end
