# frozen_string_literal: true

# require 'spree/core'
# require 'solidus_core'
# require 'solidus_support'
require 'solidus_picker'

module SolidusPicker
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_picker'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'solidus_picker.pub_sub' do |app|
      unless SolidusSupport::LegacyEventCompat.using_legacy?
        app.reloader.to_prepare do
          ::Spree::Bus.register(:'solidus_picker.tracker.updated')
        end
      end
    end
  end
end
