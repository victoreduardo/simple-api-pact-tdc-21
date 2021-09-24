require 'spec_helper'

shared_examples_for :create_endpoint do
  let(:created) { described_class.last }

  it 'should create the record and respond with a 201' do
    expect do
      post create_url, params: params
    end.to(change { described_class.count }.by(1))

    expect(response).to have_http_status(:created)
  end

  it 'should respond with the created record' do
    post create_url, params: params

    expect(response).to have_http_status(:created)

    response_attrs = json_response['data']

    expect(json_response['data']['id'].to_i).to be created.id

    create_attributes.each do |attribute|
      response_value = response_attrs[attribute.dasherize.to_s]
      expected_value = created.send(attribute.to_sym)

      case described_class.columns_hash[attribute.underscore.to_s]&.type || expected_value.class.name
      when :decimal, 'BigDecimal'
        expect(response_value.to_d).to eq expected_value
      when :float, 'Float'
        expect(response_value.to_f).to be_within(0.00000001).of expected_value
      when :datetime
        expect(Time.parse(response_value).utc).to be_within(1.second).of expected_value
      else
        expect(response_value).to eq expected_value
      end
    end
  end
end
