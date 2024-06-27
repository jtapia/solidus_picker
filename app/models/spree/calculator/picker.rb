# frozen_string_literal: true

require 'spree/calculator'

module Spree
  class Calculator::Picker < Calculator
    def compute(object = nil)
      if object && preferred_currency.casecmp(object.currency).zero?
        preferred_amount
      else
        0
      end
    end
  end
end
