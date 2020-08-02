module Chambermaid
  class Railtie < Rails::Railtie
    config.before_configuration do
      Chambermaid.logger = Rails.logger
      Chambermaid.load!
    end
  end
end
