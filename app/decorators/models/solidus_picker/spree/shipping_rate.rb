# frozen_string_literal: true

module SolidusPicker
  module Spree
    module ShippingRate
      def name
        read_attribute(:name) || super
      end

      ::Spree::ShippingRate.prepend self
    end
  end
end
