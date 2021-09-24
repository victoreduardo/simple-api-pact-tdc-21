require 'spec_helper'

shared_examples_for :index_empty_endpoint do
  it 'serializes none based on access' do
    get index_url

    expect(response).to have_http_status(:success)
    expect(json_response).to have_records([])
  end
end
