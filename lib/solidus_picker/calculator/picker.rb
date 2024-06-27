# # frozen_string_literal: true

# # require 'spree/calculator'

# module SolidusPicker
#   module Calculator
#     class Picker < ::Spree::Calculator
#       # binding.pry
#       preference :amount, :decimal, default: 0
#       # preference :currency, :string, default: ->{ Spree::Config[:currency] }

#       def compute(object = nil)
#         # binding.pry
#         if object && preferred_currency.casecmp(object.currency).zero?
#           preferred_amount
#         else
#           0
#         end
#       end
#     end
#   end
# end
