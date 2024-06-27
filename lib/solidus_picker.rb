# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'
require 'spree/core'
require 'deface'

require 'solidus_picker/version'
require 'solidus_picker/engine'
require 'solidus_picker/configuration'
require 'solidus_picker/estimator'
require 'solidus_picker/http_client'
require 'solidus_picker/services/rate'
require 'solidus_picker/utilities/constants'
require 'solidus_picker/utilities/system'
require 'solidus_picker/client'

module SolidusPicker
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end
