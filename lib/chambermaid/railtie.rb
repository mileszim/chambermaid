module Chambermaid
  class Railtie < Rails::Railtie
    config.after_initialize do
      Chambermaid.logger = Rails.logger
      Chambermaid.load!
    end
  end
end
