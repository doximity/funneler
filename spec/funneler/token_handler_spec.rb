require 'spec_helper'

RSpec.describe Funneler::TokenHandler do
  subject(:handler) { Funneler::TokenHandler }

  let(:jwt_key) { 'secret_key' }
  let(:jwt_algorithm) { 'HS256' }
  let(:none_algorithm) { 'none' }

  let(:configuration) {
    Funneler::Configuration.new( jwt_key:jwt_key,
                               jwt_algorithm: jwt_algorithm,
                               expires_in_days: 1)
  }

  before {
    allow(Funneler).to receive(:configuration).
      and_return(configuration)
  }

  context '.generate_token' do
    it 'generates a JWT token with the given data' do
      token = handler.generate_token(data: {foo: :bar})
      expect(token).to_not be_nil

      data, headers = JWT.decode(token, jwt_key, true, algorithm: jwt_algorithm)
      expect(data['foo']).to eq('bar')
      expect(headers).to eq("alg"=>jwt_algorithm)
    end

    it 'fails if the wrong algorithm is used' do
      token = handler.generate_token(data: {foo: :bar})
      expect(token).to_not be_nil

      expect { JWT.decode(token, jwt_key, true, algorithm: none_algorithm) }
        .to raise_error(JWT::IncorrectAlgorithm)
    end
  end

  context '.extract_data_from' do
    let(:token) {
      JWT.encode({foo: :bar, exp: (Time.now + 24*3600).to_i },
                 jwt_key, jwt_algorithm)
    }

    it 'extracts the data hash from the token' do
      data = handler.extract_data_from(token)
      expect(data['foo']).to eq('bar')
    end

    it 'raises an exception when the token has expired' do
      expect { handler.extract_data_from(token) }.not_to raise_error

      Timecop.freeze(DateTime.now + 2) do
        expect { handler.extract_data_from(token) }.
          to raise_error(JWT::ExpiredSignature)
      end
    end
  end

  it 'can decode the token it generates' do
    token = handler.generate_token(data: {foo: :bar})
    data = handler.extract_data_from(token)
    expect(data).to include('foo' => 'bar')
  end
end
