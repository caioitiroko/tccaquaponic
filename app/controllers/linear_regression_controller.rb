class LinearRegressionController < ApplicationController
  include LinearRegressionHelper

  def index
  end

  def result
    expectedGrowth = getExpectedGrowth(params[:lux], params[:n_fish], params[:ph], params[:temperature], params[:water_flow], params[:previous_length], params[:previous_width])
    @expectedGrowthLength = expectedGrowth[0].round(3)
    @expectedGrowthWidth = expectedGrowth[1].round(3)
    @expectedLength = (@expectedGrowthLength + params[:previous_length].to_f).round(3)
    @expectedWidth = (@expectedGrowthWidth + params[:previous_width].to_f).round(3)
    @determinationCoefficientLength = getDeterminationCoefficient[0].round(3)
    @determinationCoefficientWidth = getDeterminationCoefficient[1].round(3)
    @widthStyle =
      if @determinationCoefficientWidth < 0.5
        "red"
      elsif @determinationCoefficientWidth < 0.8
        "yellow"
      else
        "green"
      end
    @lengthStyle =
      if @determinationCoefficientLength < 0.5
        "red"
      elsif @determinationCoefficientLength < 0.8
        "yellow"
      else
        "green"
      end

    Rails.logger.warn "#{expectedGrowth}"
  end
end
