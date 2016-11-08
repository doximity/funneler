require 'jwt'

module Funneler
  class TokenHandler
    class << self
      def generate_token(data:, expires_in_days: nil)
        key = Funneler.configuration.jwt_key
        algorithm = Funneler.configuration.jwt_algorithm

        expires_in_days ||= Funneler.configuration.expires_in_days
        if expires_in_days
          expiration = Time.now + (expires_in_days * 24 * 60 * 60)
          data = { exp: expiration.to_i }.merge(data)
        end

        JWT.encode(data, key, algorithm)
      end

      def extract_data_from(token)
        key = Funneler.configuration.jwt_key
        algorithm = Funneler.configuration.jwt_algorithm
        verify = (algorithm != nil || key != nil)
        data, _ = JWT.decode(token, key, verify, algorithm: algorithm)
        data
      end
    end
  end
end
