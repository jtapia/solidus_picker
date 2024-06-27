# frozen_string_literal: true

module SolidusPicker
  module Spree
    module Carton
      def self.prepended(base)
        base.after_create :track_via_picker
      end

      def picker_tracker
        return @picker_tracker if @picker_tracker

        if picker_tracker_id.present?
          @picker_tracker = Picker::Tracker.retrieve(picker_tracker_id)
        else
          @picker_tracker = Picker::Tracker.create(
            tracking_code: tracking,
            carrier: shipping_method.carrier,
          )

          update!(picker_tracker_id: @picker_tracker.id)
        end

        @picker_tracker
      end

      private

      def track_via_picker
        return unless SolidusPicker.configuration.track_all_cartons

        picker_tracker
      end

      ::Spree::Carton.prepend self
    end
  end
end
