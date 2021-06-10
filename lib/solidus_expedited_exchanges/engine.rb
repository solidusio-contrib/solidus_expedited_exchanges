# frozen_string_literal: true

require 'spree/core'

module SolidusExpeditedExchanges
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_expedited_exchanges'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Spree::Order.prepend SolidusExpeditedExchanges::OrderExtension
      Spree::ReturnAuthorization.include SolidusExpeditedExchanges::ReturnAuthorizationExtension
      Spree::AppConfiguration.include SolidusExpeditedExchanges::AppConfigurationExtension
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
