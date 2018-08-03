class LinearRegressionController < ApplicationController
  include LinearRegressionHelper

  def index
  end

  def result
    inputs = [params[:lux], params[:n_fish], params[:ph], params[:temperature], params[:water_flow], params[:previous_length], params[:previous_width]].map(&:to_f)

    results = getRegressionResult(inputs)

    @constantsL = results[:constantsL].map { |c| c.round(3)}
    @constantsW = results[:constantsW].map { |c| c.round(3)}

    @expectedGrowthLength = results[:expectedGrowthLength].round(3)
    @expectedGrowthWidth = results[:expectedGrowthWidth].round(3)
    @expectedLength = (@expectedGrowthLength + params[:previous_length].to_f).round(3)
    @expectedWidth = (@expectedGrowthWidth + params[:previous_width].to_f).round(3)
    @determinationCoefficientLength = results[:coefficientL].round(3)
    @determinationCoefficientWidth = results[:coefficientW].round(3)
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
  end
end
