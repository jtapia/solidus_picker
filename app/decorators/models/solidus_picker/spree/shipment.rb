# frozen_string_literal: true

module SolidusPicker
  module Spree
    module Shipment
      def self.prepended(base)
        # base.state_machine.before_transition(
        #   to: :shipped,
        #   do: :buy_picker_rate,
        #   if: -> { SolidusPicker.configuration.purchase_labels }
        # )

        # base.delegate(
        #   :picker_rate_id,
        #   :picker_shipment_id,
        #   to: :selected_shipping_rate,
        #   prefix: :selected,
        #   allow_nil: true,
        # )
      end

      def picker_shipment
        # binding.pry
        # return unless selected_picker_shipment_id

        @picker_shipment ||= ::Picker::Shipment.retrieve(selected_picker_shipment_id)
      end

      def picker_postage_label_url
        picker_shipment&.postage_label&.label_url
      end

      private

      def buy_picker_rate
        rate = picker_shipment.rates.find do |picker_rate|
          picker_rate.id == selected_picker_rate_id
        end

        picker_shipment.buy(rate)

        self.tracking = picker_shipment.tracking_code
      end

      ::Spree::Shipment.prepend self
    end
  end
end
