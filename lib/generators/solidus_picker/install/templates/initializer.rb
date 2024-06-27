# frozen_string_literal: true

Picker.api_key = 'YOUR_API_KEY_HERE'

SolidusPicker.configure do |config|
  # Purchase labels from Picker when shipping shipments in Solidus?
  # config.purchase_labels = true

  # Create a tracker in Picker and receive webhooks for all cartons?
  # config.track_all_cartons = false

  # A class that responds to `#compute`, accepting an `Picker::Rate`
  # instance and returning the cost for that rate.
  # config.shipping_rate_calculator_class = 'SolidusPicker::ShippingRateCalculator'

  # A class that responds to `#shipping_method_for`, accepting an
  # `Picker::Rate` instance and returning the shipping method for
  # that rate.
  # config.shipping_method_selector_class = 'SolidusPicker::ShippingMethodSelector'

  # A class that responds to '#compute', accepting a `SolidusPicker::ReturnAuthorization`
  # instance or a `Spree::Stock::Package` instance and returing the `SolidusPicker::ParcelDimension` object.
  # The `SolidusPicker::Calculator::BaseDimensionCalculator` class can be extended to have a common
  # functionality.
  # config.parcel_dimension_calculator_class = 'SolidusPicker::Calculator::WeightDimensionCalculator'
end
