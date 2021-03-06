require 'spec_helper'

RSpec.describe LiveEditor::API::Themes::Region do
  let(:client) do
    LiveEditor::API::Client.new domain: 'example.liveeditorapp.com', access_token: '1234567890',
                                refresh_token: '0987654321'
  end

  let(:theme_id)  { SecureRandom.uuid }
  let(:layout_id) { SecureRandom.uuid }
  let(:region_id) { SecureRandom.uuid }

  before { LiveEditor::API::client = client }

  describe '.update' do
    context 'with valid input' do
      let(:response) do
        LiveEditor::API::Themes::Region.update theme_id, layout_id, region_id, title: 'Main', var_name: 'the-main',
                                                max_num_content: 4
      end

      let(:request_payload) do
        {
          data: {
            type: 'regions',
            id: region_id,
            attributes: {
              'title' => 'Main',
              'var-name' => 'the-main',
              'max-num-content' => 4
            }
          }
        }
      end

      let(:response_payload) do
        {
          'data' => {
            'type' => 'regions',
            'id' => region_id,
            'attributes' => {
              'title' => 'Main',
              'var-name' => 'the-main',
              'max-num-content' => 4,
              'created-at' => '2012-04-23T18:25:43.511Z',
              'updated-at' => '2012-04-24T18:25:43.511Z'
            }
          }
        }
      end

      before do
        stub_request(:patch, "http://example.api.liveeditorapp.com/themes/#{theme_id}/layouts/#{layout_id}/regions/#{region_id}")
          .with(body: request_payload.to_json, headers: { 'Authorization' => 'Bearer 1234567890' })
          .to_return(status: 200, headers: { 'Content-Type' => 'application/vnd.api+json'}, body: response_payload.to_json)
      end

      it 'is successful' do
        expect(response.success?).to eql true
      end

      it 'returns HTTP OK response' do
        expect(response.response).to be_a Net::HTTPOK
      end

      it 'returns the expected response payload' do
        expect(response.parsed_body).to eql response_payload
      end
    end # with valid input

    context 'with invalid input' do
      let(:response) do
        LiveEditor::API::Themes::Region.update theme_id, layout_id, region_id, title: 'Main', var_name: 'the-main',
                                               max_num_content: 'bananas'
      end

      let(:request_payload) do
        {
          data: {
            type: 'regions',
            id: region_id,
            attributes: {
              'title' => 'Main',
              'var-name' => 'the-main',
              'max-num-content' => 'bananas'
            }
          }
        }
      end

      let(:response_payload) do
        {
          'errors' => [
            {
              'source' => {
                'pointer' => '/data/attributes/max-num-content'
              },
              'detail' => 'is not a number'
            }
          ]
        }
      end

      before do
        stub_request(:patch, "http://example.api.liveeditorapp.com/themes/#{theme_id}/layouts/#{layout_id}/regions/#{region_id}")
          .with(body: request_payload.to_json, headers: { 'Authorization' => 'Bearer 1234567890' })
          .to_return(status: 422, headers: { 'Content-Type' => 'application/vnd.api+json'}, body: response_payload.to_json)
      end

      it 'is error' do
        expect(response.error?).to eql true
      end

      it 'returns HTTP Unprocessable Entity response' do
        expect(response.response).to be_a Net::HTTPUnprocessableEntity
      end

      it 'returns the expected response payload' do
        expect(response.errors).to eql({
          'max-num-content' => ['is not a number']
        })
      end
    end # with invalid input
  end # .update
end
