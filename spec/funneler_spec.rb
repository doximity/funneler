require 'spec_helper'

RSpec.describe Funneler do
  before { ENV["JWT_KEY"] = "abc123" }

  let(:configuration) { Funneler.configuration }
  before { allow(Funneler).to receive(:configuration).and_return(configuration) }

  it 'has a version number' do
    expect(Funneler::VERSION).not_to be nil
  end

  context ".configuration" do
    it 'is the configuration for the funneler system' do
      expect(configuration).to be_kind_of(Funneler::Configuration)
    end
  end

  context ".configure" do
    it 'allows funneler to be configured via a block syntax' do
      expect(configuration.jwt_key).to_not be_nil
      Funneler.configure do |config|
        config.jwt_key = 'foobar'
        config.jwt_algorithm = 'HS256'
      end
      expect(configuration.jwt_key).to eq('foobar')
      expect(configuration.jwt_algorithm).to eq('HS256')
    end
  end

  context ".from_token" do
    it 'provides a wrapper around `TokenHandler.extract_data_from(token)`' do
      allow(Funneler::TokenHandler).to receive(:extract_data_from).
        with('foo').
        and_return({})
      expect(Funneler.from_token(token: 'foo')).
        to be_instance_of(Funneler::Funnel)
    end

    it 'wraps any JWT::DecodeError in an InvalidTokenError' do
      allow(Funneler::TokenHandler).to receive(:extract_data_from).
        with('foo').
        and_raise(JWT::DecodeError, "oh no")

      expect { Funneler.from_token(token: 'foo') }.
        to raise_error(Funneler::InvalidTokenError,
                       "Invalid token 'foo': oh no")
    end
  end

  context ".from_url" do
    let(:routes) { ['/a', '/b'] }
    it 'extracts the funnel from the funnel_token in the given url' do
      Timecop.freeze do
        funnel = Funneler.from_routes(routes: routes)
        new_funnel = Funneler.from_url(url: funnel.next_page)
        expect(new_funnel.data).to include('routes' => routes)
        expect(new_funnel.data).to include('current_page_index' => 1)
        expect(funnel.data).to include('meta' => {})
      end
    end
  end

  context ".from_routes" do
    let(:routes) { ['/a', '/b'] }
    it 'builds a funnel with the given routes and meta' do
      funnel = Funneler.from_routes(routes: routes, meta: {name: 'Ryan'})
      expect(funnel.data).to include('routes' => routes)
      expect(funnel.data).to include('current_page_index' => 0)
      expect(funnel.data).to include('meta' => {name: 'Ryan'})
    end
  end
end
