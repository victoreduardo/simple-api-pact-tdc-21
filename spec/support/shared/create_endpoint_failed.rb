require 'spec_helper'

shared_examples_for :create_endpoint_failed do |http_status|
  it 'should not create the record and respond with an error' do
    expect do
      post create_url, params: params
    end.not_to(change(described_class, :count))

    expect(response).to have_http_status(http_status)
  end
end
