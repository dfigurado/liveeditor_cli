require 'spec_helper'

RSpec.describe LiveEditor::API::Themes::Block do
  let(:client) do
    LiveEditor::API::Client.new domain: 'example.liveeditorapp.com', access_token: '1234567890',
                                refresh_token: '0987654321'
  end

  let(:theme_id) { SecureRandom.uuid }
  let(:content_template_id) { SecureRandom.uuid }

  before { LiveEditor::API::client = client }

  describe '.create' do
    context 'with valid input' do
      let(:response) do
        LiveEditor::API::Themes::Block.create theme_id, content_template_id, 'Title', 'text', 0,
                                              var_name: 'title_1', description: 'A description.', required: true,
                                              inline: true
      end

      let(:request_payload) do
        {
          data: {
            type: 'blocks',
            attributes: {
              'title' => 'Title',
              'data-type' => 'text',
              'position' => 0,
              'var-name' => 'title_1',
              'description' => 'A description.',
              'required' => true,
              'inline' => true
            }
          }
        }
      end

      let(:response_payload) do
        {
          'data' => {
            'type' => 'blocks',
            'id' => '1234',
            'attributes' => {
              'title' => 'Title',
              'data-type' => 'text',
              'position' => 0,
              'var-name' => 'title_1',
              'description' => 'A description.',
              'required' => true,
              'inline' => true
            }
          }
        }
      end

      before do
        stub_request(:post, "http://example.api.liveeditorapp.com/themes/#{theme_id}/content-templates/#{content_template_id}/blocks")
          .with(body: request_payload.to_json, headers: { 'Authorization' => 'Bearer 1234567890' })
          .to_return(status: 201, headers: { 'Content-Type' => 'application/vnd.api+json'}, body: response_payload.to_json)
      end

      it 'is successful' do
        expect(response.success?).to eql true
      end

      it 'returns HTTP Created response' do
        expect(response.response).to be_a Net::HTTPCreated
      end

      it 'returns the expected response payload' do
        expect(response.parsed_body).to eql response_payload
      end
    end # with valid input

    context 'with invalid input' do
      let(:response) do
        LiveEditor::API::Themes::Block.create theme_id, content_template_id, '', 'text', 0, var_name: 'title_1',
                                              description: 'A description.', required: true, inline: true
      end

      let(:request_payload) do
        {
          data: {
            type: 'blocks',
            attributes: {
              'title' => '',
              'data-type' => 'text',
              'position' => 0,
              'var-name' => 'title_1',
              'description' => 'A description.',
              'required' => true,
              'inline' => true
            }
          }
        }
      end

      let(:response_payload) do
        {
          'errors' => [
            {
              'source' => {
                'pointer' => '/data/attributes/title'
              },
              'detail' => "can't be blank"
            }
          ]
        }
      end

      before do
        stub_request(:post, "http://example.api.liveeditorapp.com/themes/#{theme_id}/content-templates/#{content_template_id}/blocks")
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
          'title' => ["can't be blank"]
        })
      end
    end # with invalid input
  end # .update
end
