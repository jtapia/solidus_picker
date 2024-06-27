# frozen_string_literal: true

module SolidusPicker
  module Services
    class Rate
      def initialize(client)
        @client = client
      end

      # Retrieve a Rate
      def retrieve(lat:, lon:, payment_method: 'CARD', car_type: 'BIKE')
        binding.pry
        response = @client.make_request(
          method: :post,
          endpoint: 'preCheckout',
          headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          },
          body: {
            latitude: lat,
            longitude: lon,
            paymentMethod: payment_method,
            carName: car_type
          }.to_json
        )

        binding.pry
        # EasyPost::InternalUtilities::Json.convert_json_to_object(response, EasyPost::Models::Rate)
      end
    end
  end
end
