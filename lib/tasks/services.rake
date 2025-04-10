namespace :services do
  def assert_docker_compose_installed!
    unless system('docker-compose -v > /dev/null 2>&1')
      STDERR.puts <<~eos
      **************************************************
      ⛔️ ERROR: services tasks depend on Docker Compose being installed. \
      See https://docs.docker.com/compose/install/ for how to install.
      **************************************************
      eos
      exit
    end
  end

  def compose_file_path
    Rails.root.join('docker-compose.yml').to_s
  end

  def compose_env
    {
      'COMPOSE_FILE' => compose_file_path,
      'COMPOSE_PROJECT_NAME' => File.basename(Dir.pwd)
    }
  end

  desc 'Start background services for this app'
  task :up do
    puts 'Starting services...'
    assert_docker_compose_installed!

    if system(compose_env, "docker-compose up -d #{ENV['COMPOSE_ARGUMENTS']}")
      puts '✅ Success! services are running in the background. Run services:down to stop them.'
    else
      STDERR.puts '⛔️ Error! There was an error starting services.'
    end
  end

  desc 'Stop external services for this app'
  task :down do
    puts 'Stopping services...'
    assert_docker_compose_installed!

    if system(compose_env, "docker-compose down #{ENV['COMPOSE_ARGUMENTS']}")
      puts '✅ Success! services are stopped. Run services:up to start them.'
    else
      STDERR.puts '⛔️ Error! There was an error stopping services.'
    end
  end

  desc 'Remove data volumes associated with external services. Stops containers.'
  task :clean do
    puts 'Removing services data...'
    assert_docker_compose_installed!

    if system(compose_env, "docker-compose down -v #{ENV['COMPOSE_ARGUMENTS']}")
      puts '✅ Success! service volumes have been removed. Run services:up to start services and recreate volumes.'
    else
      STDERR.puts '⛔️ Error! There was an error removing service volumes.'
    end
  end
end
