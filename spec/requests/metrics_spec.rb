require 'rails_helper'

RSpec.describe Metric, type: :request do
  let(:json_response) { JSON.parse(response.body) }

  describe '#index' do
    let(:index_url) { '/metrics' }
    let(:index_attributes) { %w[id name value date created_at updated_at] }

    it_behaves_like :index_all_endpoint do
      let!(:expected_records) { create_list(:metric, 10) }
    end
    it_behaves_like :index_empty_endpoint
  end

  describe '#create' do
    let(:create_url) { '/metrics' }
    let(:create_attributes) { %w[name value date] }

    context 'with valid parameters' do
      let(:params) { { metric: { name: 'Foo Baa', value: 12.22, date: Time.zone.now } } }

      it_behaves_like :create_endpoint
    end

    context 'with invalid parameters' do
      let(:params) { { metric: { name: 'Foo Baa', value: 'value', date: Time.zone.now } } }

      it_behaves_like :create_endpoint_failed, 422
    end
  end
end
