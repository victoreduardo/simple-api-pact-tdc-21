require 'swagger_helper'

RSpec.describe 'Metrics API', type: :request do
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

      response 201, 'OK' do
        let(:metric) { { name: 'foo', value: 12.11, date: '11-11-2021 11:11' } }
        let!(:initial_count) { Metric.count }

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
          expect(Metric.count).to eq(initial_count + 1)
        end
      end

      response 422, 'invalid request' do
        let(:metric) { { name: 'foo' } }
        run_test!
      end
    end
  end
end
