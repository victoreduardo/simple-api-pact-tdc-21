class MetricsController < ApplicationController
  def index
    metrics = Metric.all.order(:date)

    render json: { data: metrics }
  end

  def create
    metric = Metric.new(metric_params)

    if metric.save
      render json: { data: metric }, status: :created
    else
      render json: { error: metric.errors }, status: :unprocessable_entity
    end
  end

  private

  def metric_params
    params.require(:metric).permit(:name, :value, :date)
  end
end
