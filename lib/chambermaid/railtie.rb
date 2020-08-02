module Chambermaid
  class Railtie < Rails::Railtie
    railtie_name :chambermaid
    
    config.before_configuration do
      Chambermaid.logger = Rails.logger
      Chambermaid.load!
    end

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
