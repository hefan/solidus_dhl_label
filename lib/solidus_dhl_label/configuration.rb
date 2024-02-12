# frozen_string_literal: true

module SolidusDhlLabel
  class Configuration
    attr_accessor :endpoint
    attr_accessor :bcs_user
    attr_accessor :bcs_password
    attr_accessor :ekp
    attr_accessor :procedure_id
    attr_accessor :participation_id
    attr_accessor :api_key
    attr_accessor :consignor
    attr_accessor :default_unit_weight
    attr_accessor :debug_output
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
