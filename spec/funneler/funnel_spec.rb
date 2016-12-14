require 'spec_helper'

RSpec.describe Funneler::Funnel do

  let(:routes) { ['first', 'second', 'third'] }
  let(:configuration) {
    Funneler::Configuration.new(jwt_key: 'foobar', jwt_algorithm: 'HS256')
  }

  before { allow(Funneler).to receive(:configuration).and_return(configuration) }

  context "#next_page" do
    it 'returns nil when there are no routes' do
      expect(Funneler::Funnel.new.next_page).to eq(nil)
    end

    it 'returns the next route with a token parameter' do
      data = { 'routes' => routes }
      url = Funneler::Funnel.new(data).next_page
      verify_url(url, route: 'second', current_page_index: 1)
    end

    it 'returns the page after the current index' do
      data = { 'routes' => routes, 'current_page_index' => 1 }
      url = Funneler::Funnel.new(data).next_page
      verify_url(url, route: 'third', current_page_index: 2)
    end
  end

  context "#previous_page" do
    it 'returns nil when no default is specified and there are no routes' do
      expect(Funneler::Funnel.new.previous_page).to eq(nil)
    end

    it 'returns the previous route with a token parameter' do
      data = { 'routes' => routes, 'current_page_index' => 2 }
      url = Funneler::Funnel.new(data).previous_page
      verify_url(url, route: 'second', current_page_index: 1)
    end

    it 'returns the first page when the index is already the first page' do
      data = { 'routes' => routes, 'current_page_index' => 0 }
      url = Funneler::Funnel.new(data).previous_page
      verify_url(url, route: 'first', current_page_index: 0)
    end
  end

  context "#first_page" do
    it 'returns nil when no routes are specified' do
      expect(Funneler::Funnel.new.first_page).to eq(nil)
    end

    it 'returns the first route with a token parameter' do
      data = { 'routes' => routes, 'current_page_index' => 42 }
      url = Funneler::Funnel.new(data).first_page
      verify_url(url, route: 'first', current_page_index: 0)
    end

    it 'allows for appending extra parameters to the url' do
      data = { 'routes' => routes, 'current_page_index' => 42 }
      url = Funneler::Funnel.new(data).first_page(foo: :bar, a: 3)
      verify_url(url, route: 'first', current_page_index: 0)
      expect(url).to match(/^first\?funnel_token=[\w\-_]+\.[\w\-_]+\.[\w\-_]+&foo=bar&a=3/)
    end
  end

  context 'integration' do
    let(:funnel) { Funneler::Funnel.new('routes' => routes) }

    it 'allows moving between pages using the token' do
      url = funnel.first_page
      verify_url(url, route: 'first', current_page_index: 0)

      funnel = funnel_from_url(url)
      url = funnel.next_page
      verify_url(url, route: 'second', current_page_index: 1)

      funnel = funnel_from_url(url)
      url = funnel.next_page
      verify_url(url, route: 'third', current_page_index: 2)

      funnel = funnel_from_url(url)
      expect(funnel.next_page).to be_nil

      url = funnel.previous_page
      verify_url(url, route: 'second', current_page_index: 1)
    end
  end

  context '#is_last_page?' do
    let(:routes) { ['first', 'second', 'third'] }
    it 'is true when there are no routes' do
      expect(Funneler::Funnel.new.is_last_page?).to eq(true)
    end

    it 'is false when the index is not beyond the total routes' do
      funnel = Funneler::Funnel.new('routes' => routes)
      expect(funnel.is_last_page?).to eq(false)
    end

    it 'is false when the index is not beyond the total routes' do
      data = { 'routes' => routes, 'current_page_index' => 1  }
      funnel = Funneler::Funnel.new(data)
      expect(funnel.is_last_page?).to eq(false)
    end

    it 'is true when the index is on the last page' do
      data = { 'routes' => [:a, :b], 'current_page_index' => 2 }
      funnel = Funneler::Funnel.new(data)
      expect(funnel.is_last_page?).to eq(true)
    end

    it 'is true when the index exceeds the # of routes' do
      data = { 'routes' => [:a, :b], 'current_page_index' => 42 }
      funnel = Funneler::Funnel.new(data)
      expect(funnel.is_last_page?).to eq(true)
    end
  end

  context '#meta' do
    it 'exposes the application specific meta data' do
      data = { 'meta' => {foo: :bar} }
      funnel = Funneler::Funnel.new(data)
      expect(funnel.meta).to eq(foo: :bar)
    end
  end

  def verify_url(url, route:, current_page_index:)
    expect(url).to match(/^#{route}\?funnel_token=[\w\-_]+\.[\w\-_]+\.[\w\-_]/)
    new_funnel = funnel_from_url(url)
    expect(new_funnel.data).to include('current_page_index' => current_page_index)
  end

  def funnel_from_url(url)
    uri = URI.parse(url)
    params = Hash[URI.decode_www_form(uri.query || "")]
    token = params['funnel_token']
    Funneler.from_token(token: token)
  end
end
