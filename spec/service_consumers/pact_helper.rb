require "pact/consumer/rspec"
require 'rails_helper'

require './spec/service_consumers/provider_states/provider_states_for_metric'

pact_url = ENV.fetch('METRIC_UI_PACT_URI')

Pact.service_provider "Metric App" do
  honours_pact_with 'metric-provider' do
    pact_uri(pact_url)

    pact_uri Rails.root.join('pacts', 'metric-consumer-metric-provider.json')
  end
end
