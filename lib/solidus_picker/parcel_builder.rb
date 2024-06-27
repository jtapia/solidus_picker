# frozen_string_literal: true

module SolidusPicker
  class ParcelBuilder
    class << self
      def from_package(package)
        parcel_dimension = SolidusPicker
                           .configuration
                           .parcel_dimension_calculator_class
                           .new
                           .compute(package)

        ::Picker::Parcel.create(parcel_dimension.to_h)
      end

      def from_return_authorization(return_authorization)
        parcel_dimension = SolidusPicker
                           .configuration
                           .parcel_dimension_calculator_class
                           .new
                           .compute(return_authorization)

        ::Picker::Parcel.create(parcel_dimension.to_h)
      end
    end
  end
end
