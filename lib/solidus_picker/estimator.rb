# frozen_string_literal: true

module SolidusPicker
  class Estimator
    def shipping_rates(package, _frontend_only = true)
      # binding.pry
      # picker_rates = ShipmentBuilder.from_package(package).rates.sort_by(&:rate)

      shipping_rates = picker_rates.map { |rate| build_shipping_rate(rate) }.compact
      shipping_rates.min_by(&:cost)&.selected = true

      shipping_rates
    end

    private

    def build_shipping_rate(rate)
      shipping_method = shipping_method_selector.shipping_method_for(rate)
      return unless shipping_method.available_to_users?

      ::Spree::ShippingRate.new(
        name: "#{rate.carrier} #{rate.service}",
        cost: shipping_rate_calculator.compute(rate),
        picker_shipment_id: rate.shipment_id,
        picker_rate_id: rate.id,
        shipping_method: shipping_method,
      )
    end

    def shipping_rate_calculator
      @shipping_rate_calculator ||= SolidusPicker.configuration.shipping_rate_calculator_class.new
    end

    def shipping_method_selector
      @shipping_method_selector ||= SolidusPicker.configuration.shipping_method_selector_class.new
    end
  end
end
