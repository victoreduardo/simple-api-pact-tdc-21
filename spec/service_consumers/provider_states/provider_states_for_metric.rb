Pact.provider_states_for 'metric-consumer' do
  provider_state 'provider allows metric creation' do
    set_up do |params|
      Metric.create(params)
    end
  end
end
