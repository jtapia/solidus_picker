# frozen_string_literal: true

module SolidusPicker
  class Configuration
    attr_accessor :api_key, :production
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    alias config configuration

    def configure
      yield configuration
    end
  end
end
