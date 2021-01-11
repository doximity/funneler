# frozen_string_literal: true

module Funneler
  class Configuration
    attr_accessor :jwt_key,
                  :jwt_algorithm,
                  :expires_in_days

    def initialize(options = {})
      @jwt_key = options[:jwt_key]
      @jwt_algorithm = options[:jwt_algorithm]
      @expires_in_days = options.fetch(:expires_in_days, 14)
    end
  end
end
