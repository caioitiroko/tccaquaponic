class LinearRegressionController < ApplicationController
  include LinearRegressionHelper

  GRAPH_GRAP = 1

  def index
  end

  def result
    results = getRegressionResult(params)

    @constantsL = results[:constantsL].map { |c| c.round(3)}
    @constantsW = results[:constantsW].map { |c| c.round(3)}

    @expectedGrowthLength = results[:expectedGrowthLength].round(3)
    @expectedGrowthWidth = results[:expectedGrowthWidth].round(3)
    @expectedLength = (@expectedGrowthLength + params[:previous_length].to_f).round(3)
    @expectedWidth = (@expectedGrowthWidth + params[:previous_width].to_f).round(3)
    @determinationCoefficientLength = results[:coefficientL].round(3)
    @determinationCoefficientWidth = results[:coefficientW].round(3)

    errorMinL = results[:errorMinL].round(3)
    errorMaxL = results[:errorMaxL].round(3)
    errorMinW = results[:errorMinW].round(3)
    errorMaxW = results[:errorMaxW].round(3)

    graphLength = Hash[results[:sizeGraphLength].map.with_index { |l, i| [(DateTime.now+i).strftime("%F"), l] }]
    graphLengthWithErrorMin = Hash[results[:sizeGraphLength].map.with_index { |l, i| [(DateTime.now+i).strftime("%F"), l + errorMinL] }]
    graphLengthWithErrorMax = Hash[results[:sizeGraphLength].map.with_index { |l, i| [(DateTime.now+i).strftime("%F"), l + errorMaxL] }]
    graphWidth = Hash[results[:sizeGraphWidth].map.with_index { |w, i| [(DateTime.now+i).strftime("%F"), w] }]
    graphWidthWithErrorMin = Hash[results[:sizeGraphWidth].map.with_index { |w, i| [(DateTime.now+i).strftime("%F"), w + errorMinW] }]
    graphWidthWithErrorMax = Hash[results[:sizeGraphWidth].map.with_index { |w, i| [(DateTime.now+i).strftime("%F"), w + errorMaxW] }]

    @graphMinLength = (results[:sizeGraphLength].min + errorMinL - GRAPH_GRAP).floor
    @graphMaxLength = (results[:sizeGraphLength].max + errorMaxL + GRAPH_GRAP).ceil

    @graphMinWidth = (results[:sizeGraphWidth].min + errorMinW - GRAPH_GRAP).floor
    @graphMaxWidth = (results[:sizeGraphWidth].max + errorMaxW + GRAPH_GRAP).ceil

    @graphDataLength = [
      {name: "Comprimento", data: graphLength},
      {name: "Comprimento mínimo", data: graphLengthWithErrorMin},
      {name: "Comprimento máximo", data: graphLengthWithErrorMax},
    ]

    @graphDataWidth = [
      {name: "Largura", data: graphWidth},
      {name: "Largura mínima", data: graphWidthWithErrorMin},
      {name: "Largura máxima", data: graphWidthWithErrorMax},
    ]

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
