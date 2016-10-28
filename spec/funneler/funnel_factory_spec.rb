require 'spec_helper'

RSpec.describe Funneler::FunnelFactory do

  subject(:factory) { Funneler::FunnelFactory }
  let(:route_generator) { ->(_) { ['a', 'b'] } }

  context '.build' do
    it 'returns a new funnel with the routes generated for the funnel type' do
      funnel = factory.build(route_generator: route_generator,
                             params: {},
                             expires_in_days: 42)
      expect(funnel.data).to eq('routes' => ['a', 'b'],
                                'expires_in_days' => 42)
    end
  end
end
