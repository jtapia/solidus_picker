# frozen_string_literal: true

require_dependency 'spree/calculator'
require_dependency 'spree/shipping_calculator'

module Spree
  module Calculator::Shipping
    class Picker < ShippingCalculator
      def compute_package(package)
        client ||= SolidusPicker::Client.new(
          api_key: SolidusPicker.configuration.api_key,
          package: package
        )
      end
    end
  end
end
