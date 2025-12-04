require 'spec_helper'

RSpec.describe Funneler::FunnelFactory do

  subject(:factory) { Funneler::FunnelFactory }
  let(:route_generator) { ->(_) { ['a', 'b'] } }

  context '.build' do
    it 'returns a new funnel with the routes generated for the funnel type' do
      funnel = factory.build(route_generator: route_generator,
                             params: {},
                             meta: { name: 'Santa' },
                             expires_in_days: 42)
      expect(funnel.data).to eq('routes' => ['a', 'b'],
                                'expires_in_days' => 42,
                                'meta' => {name: 'Santa'})
    end

    context 'with step titles' do
      let(:route_generator) { ->(_) { [['a', 'First page'], ['b', 'Second page']] } }

      it 'returns a new funnel with the routes generated for the funnel type' do
        funnel = factory.build(route_generator: route_generator,
                               params: {},
                               meta: { name: 'Santa' },
                               expires_in_days: 42)
        expect(funnel.routes).to eq(["a", "b"])
        expect(funnel.titles).to eq(["First page", "Second page"])
        expect(funnel.meta).to eq({ name: "Santa" })
      end
    end
  end
end
