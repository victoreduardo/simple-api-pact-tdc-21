require 'spec_helper'

shared_examples_for :index_all_endpoint do
  it 'serializes all' do
    get index_url

    expect(response).to have_http_status(:success)
    expect(json_response).to have_records(expected_records)

    response_attrs = json_response['data'].first || {}
    expect(response_attrs.keys.sort).to eq index_attributes.sort
  end
end
