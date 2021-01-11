# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Funneler::FunnelFactory do
  subject(:factory) { Funneler::FunnelFactory }
  let(:route_generator) { ->(_) { %w[a b] } }

  context '.build' do
    it 'returns a new funnel with the routes generated for the funnel type' do
      funnel = factory.build(route_generator: route_generator,
                             params: {},
                             meta: { name: 'Santa' },
                             expires_in_days: 42)
      expect(funnel.data).to eq('routes' => %w[a b],
                                'expires_in_days' => 42,
                                'meta' => { name: 'Santa' })
    end
  end
end
