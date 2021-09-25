require 'swagger_helper'

RSpec.describe Metric, type: :request do
  path '/metrics' do
    get 'Retrieves list of metrics' do
      tags 'Metrics'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'OK' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string, nullable: false },
            value: { type: :number, nullable: false },
            date: { type: :datetime, nullable: false },
            created_at: { type: :datetime, nullable: false },
            updated_at: { type: :datetime, nullable: false }
          }

        run_test!
      end
    end

    post 'Creates a metric' do
      tags 'Metrics'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :metric,
        in: :body,
        schema: {
          type: :object,
          properties: {
            name: { type: :string },
            value: { type: :number },
            date: { type: 'date-time' }
          },
          required: %w[name value date]
        }

      response '200', 'OK' do
        let!(:initial_count) { described_class.count }

        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string, nullable: false },
            value: { type: :number, nullable: false },
            date: { type: 'date-time', nullable: false },
            created_at: { type: 'date-time', nullable: false },
            updated_at: { type: 'date-time', nullable: false }
          }

        run_test! do
          expect(described_class.count).to eq(initial_count + 1)
        end
      end
    end
  end
end
