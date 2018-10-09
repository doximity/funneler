require 'jwt'

require "funneler/version"
require "funneler/configuration"
require "funneler/token_handler"
require "funneler/funnel"
require "funneler/funnel_factory"
require "funneler/controller_methods"

module Funneler
  Error = Class.new(StandardError)
  InvalidTokenError = Class.new(Error)
  UnknownFunnelType = Class.new(Error)

  class << self
    attr_reader :configuration

    def configuration
      @configuration ||= Funneler::Configuration.new
    end

    def configure
      yield(configuration)
    end

    def from_token(token:)
      data = Funneler::TokenHandler.extract_data_from(token)
      Funneler::Funnel.new(data)
    rescue JWT::DecodeError => e
      raise InvalidTokenError, "Invalid token '#{token}': #{e.message}"
    end

    def build(route_generator:, params: {}, expires_in_days: nil, meta: {})
      Funneler::FunnelFactory.build(route_generator: route_generator,
                                   params: params,
                                   meta: meta,
                                   expires_in_days: expires_in_days)
    end

    def from_routes(routes: {}, meta: {})
      Funnel.new('routes' => routes,
                 'current_page_index' => 0,
                 'meta' => meta)
    end

    def from_url(url:)
      uri = URI.parse(url)
      params = Hash[URI.decode_www_form(uri.query || "")]
      token = params['funnel_token']
      from_token(token: token)
    end
  end

end
