# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Funneler::Configuration do
  let(:two_weeks) { 14 }
  let(:forty_two_weeks) { 42 * 7 }

  it 'provides default values' do
    config = Funneler::Configuration.new
    expect(config.jwt_key).to be_nil
    expect(config.jwt_algorithm).to be_nil
    expect(config.expires_in_days).to eq(two_weeks)
  end

  it 'is initialized with a hash' do
    jwt_key = 'foo'
    jwt_algorithm = 'bar'
    expires_in_days = forty_two_weeks
    config = Funneler::Configuration.new(jwt_key: jwt_key,
                                         jwt_algorithm: jwt_algorithm,
                                         expires_in_days: expires_in_days)
    expect(config.jwt_key).to eq('foo')
    expect(config.jwt_algorithm).to eq('bar')
    expect(config.expires_in_days).to eq(forty_two_weeks)
  end
end
