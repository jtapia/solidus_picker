# # frozen_string_literal: true

# require_dependency 'spree/calculator'
# require_dependency 'spree/shipping_calculator'

# module SolidusPicker
#   module Calculator
#     module Shipping
#       class Picker < ::Spree::ShippingCalculator
#         preference :amount, :decimal, default: 0
#         # preference :currency, :string, default: ->{ Spree::Config[:currency] }

#         def compute_package(package)
#           # binding.pry
#           preferred_amount
#         end
#       end
#     end
#   end
# end
