module Funneler
  class FunnelFactory

    class << self
      def build(route_generator:, params: {}, expires_in_days: nil, meta: {})
        return nil unless route_generator.respond_to?(:call)

        routes = route_generator.call(params)
        Funnel.new('routes' => routes,
                   'expires_in_days' => expires_in_days,
                   'meta' => meta)
      end
    end
  end
end
