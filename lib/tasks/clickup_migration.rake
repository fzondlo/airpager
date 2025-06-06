require "uri"
require "net/http"

namespace :clickup do
  # bundle exec rake clickup:migration 1003 up
  # NOTE you must pass in a valid migration number, will not do that here as
  # these actions are destructive. BE CAREFUL!
  desc "Run clickup migrations"
  task migration: :environment do
    unless ARGV[1].match?(/\A\d+\z/) && %w[up down].include?(ARGV[2])
      raise ArgumentError, <<~ERROR_MSG
          Invalid arguments passed in. Use this format to call migrations:
          bundle exec rake clickup:migration 1 up

          These actions are destructive. BE CAREFUL!
        ERROR_MSG
    end

    migration_number = ARGV[1].to_i
    migration_action = ARGV[2].to_sym # up or down
    class_name = "Migration#{migration_number}"

    migrations_ns = ClickupMigrations
    unless migrations_ns.const_defined?(class_name)
      raise ArgumentError, "No migration class found for ##{migration_number}"
    end

    klass = migrations_ns.const_get(class_name)
    klass.new.send(migration_action)
  end
end
