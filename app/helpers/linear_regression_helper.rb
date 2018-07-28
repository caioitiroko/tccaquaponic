require "matrix"

module LinearRegressionHelper
  def getAxis
    axis = Matrix[]

    GrowBedDatum.order(:date).each do |datum|
      axis = Matrix.rows(axis.to_a << [datum.temperature, datum.water_flow, datum.lux, datum.ph, datum.n_fish])
    end

    axis
  end

  def getKnowedResult
    knowedResult = Matrix[]

    GrowBedDatum.order(:date).each do |datum|
      knowedResult = Matrix.rows(knowedResult.to_a << [datum.avg_width * datum.avg_length])
    end

    knowedResult
  end

  def getConstants(axis = getAxis, knowedResult = getKnowedResult)
    x, y = [axis, knowedResult]

    xt = x.transpose
    xtx = xt * x
    c = xtx.inv
    xty = xt * y
    c * xty
  end

  def calcSingleError(constants, vector, knowedResult)
    orderedConstants = constants.transpose
    results = orderedConstants.map.with_index { |b, i| b * vector[i] }
    estimated = results.inject(0, &:+)
    estimated - knowedResult.first
  end

  def calcRegressionError(constants = getConstants, axis = getAxis, knowedResult = getKnowedResult)
    axis.row_vectors.map.with_index do |vector, i|
      calcSingleError(constants, vector, knowedResult.row(i))
    end
  end

  def calcSquareRegressionError(constants = getConstants, axis = getAxis, knowedResult = getKnowedResult)
    calcRegressionError(constants, axis, knowedResult).map { |e| e ** 2 }
  end

  # As closer to 1, more precise the linear regression prediction
  def calcDeterminationCoefficient(constants = getConstants, axis = getAxis, knowedResult = getKnowedResult)
    media = knowedResult.inject(0, &:+)/knowedResult.count
    sse = calcSquareRegressionError(constants, axis, knowedResult).inject(0, &:+)
    sst = knowedResult.map{|x| (x - media)**2}.inject(0, &:+)
    ssr = sst - sse
    ssr/sst
  end
end
