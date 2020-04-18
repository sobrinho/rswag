# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Auth Tests API', type: :request, swagger_doc: 'v1/swagger.json' do
  path '/auth-tests/basic' do
    post 'Authenticates with basic auth' do
      tags 'Auth Tests'
      operationId 'testBasicAuth'
      security [basic_auth: []]

      response '204', 'Valid credentials' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('jsmith:jspass')}" }
        run_test!
      end

      response '401', 'Invalid credentials' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('foo:bar')}" }
        run_test!
      end
    end
  end

  path '/auth-tests/api-key' do
    post 'Authenticates with an api key' do
      tags 'Auth Tests'
      operationId 'testApiKey'
      security [api_key: []]

      response '204', 'Valid credentials' do
        let(:api_key) { 'foobar' }
        run_test!
      end

      response '401', 'Invalid credentials' do
        let(:api_key) { 'barfoo' }
        run_test!
      end
    end
  end

  path '/auth-tests/basic-and-api-key' do
    post 'Authenticates with basic auth and api key' do
      tags 'Auth Tests'
      operationId 'testBasicAndApiKey'
      security [{ basic_auth: [], api_key: [] }]

      response '204', 'Valid credentials' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('jsmith:jspass')}" }
        let(:api_key) { 'foobar' }
        run_test!
      end

      response '401', 'Invalid credentials' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('jsmith:jspass')}" }
        let(:api_key) { 'barfoo' }
        run_test!
      end
    end
  end

  path '/auth-tests/basic-and-no-api-key' do
    post 'Authenticates with basic auth and no api key' do
      tags 'Auth Tests'
      operationId 'testBasicAndApiKey'

      response '401', 'Invalid credentials' do
        security [{ basic_auth: [], api_key: [] }]
        let(:Authorization) { "Basic #{::Base64.strict_encode64('jsmith:jspass')}" }
        let(:api_key) { 'foobar' }
        run_test!
      end

      response '204', 'Valid basic auth' do
        security [{ basic_auth: [] }]
        let(:Authorization) { "Basic #{::Base64.strict_encode64('jsmith:jspass')}" }
        run_test!
      end
    end
  end
end
