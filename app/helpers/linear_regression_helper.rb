require "matrix"

module LinearRegressionHelper
  def getExpectedGrowth(lux, n_fish, ph, temperature, water_flow, previous_length, previous_width)
    inputs = [lux, n_fish, ph, temperature, water_flow, previous_length, previous_width].map(&:to_f)
    puts inputs
    axis = getAxis
    knowedValuesW = getKnowedGrowthWidth
    knowedValuesL = getKnowedGrowthLength

    constantsW = getConstants(axis, knowedValuesW)
    resultsW = constantsW.map.with_index { |b, i| b * inputs[i] }
    expectedGrowthWidth = resultsW.inject(0, &:+)

    constantsL = getConstants(axis, knowedValuesL)
    resultsL = constantsL.map.with_index { |b, i| b * inputs[i] }
    expectedGrowthLength = resultsL.inject(0, &:+)

    [expectedGrowthLength, expectedGrowthWidth]
  end

  def getAxis
    axis = Matrix[]

    GrowBedDatum.order(:date).each do |datum|
      if datum.growth_width && datum.growth_length then
        axis = Matrix.rows(axis.to_a << [datum.lux, datum.n_fish, datum.ph, datum.temperature, datum.water_flow, datum.previous_datum.avg_length, datum.previous_datum.avg_width])
      end
    end

    axis
  end

  def getKnowedGrowthWidth
    knowedGrowthWidth = Matrix[]

    GrowBedDatum.order(:date).each do |datum|
      knowedGrowthWidth = Matrix.rows(knowedGrowthWidth.to_a << [datum.growth_width]) if datum.growth_width
    end

    knowedGrowthWidth
  end

  def getKnowedGrowthLength
    knowedGrowthLength = Matrix[]

    GrowBedDatum.order(:date).each do |datum|
      knowedGrowthLength = Matrix.rows(knowedGrowthLength.to_a << [datum.growth_length]) if datum.growth_length
    end

    knowedGrowthLength
  end

  def getConstants(axis, knowedValues)
    x, y = [axis, knowedValues]

    xt = x.transpose
    xtx = xt * x
    c = xtx.inv
    xty = xt * y
    c * xty
  end

  def calcSingleError(constants, vector, knowedValues)
    orderedConstants = constants.transpose
    results = orderedConstants.map.with_index { |b, i| b * vector[i] }
    estimated = results.inject(0, &:+)
    estimated - knowedValues
  end

  def calcRegressionError(constants, axis, knowedValues)
    axis.row_vectors.map.with_index do |vector, i|
      calcSingleError(constants, vector, knowedValues.row(i).first)
    end
  end

  def calcSquareRegressionError(constants, axis, knowedValues)
    calcRegressionError(constants, axis, knowedValues).map { |e| e ** 2 }
  end

  # As closer to 1, more precise the linear regression prediction
  def calcDeterminationCoefficient(constants, axis, knowedValues)
    media = knowedValues.inject(0, &:+)/knowedValues.count
    sse = calcSquareRegressionError(constants, axis, knowedValues).inject(0, &:+)
    sst = knowedValues.map{|x| (x - media)**2}.inject(0, &:+)
    ssr = sst - sse
    ssr/sst
  end

  def getDeterminationCoefficient
    axis = getAxis
    knowedValuesW = getKnowedGrowthWidth
    knowedValuesL = getKnowedGrowthLength
    constantsW = getConstants(axis, knowedValuesW)
    constantsL = getConstants(axis, knowedValuesL)
    determinationCoefficientL = calcDeterminationCoefficient(constantsL, axis, knowedValuesL)
    determinationCoefficientW = calcDeterminationCoefficient(constantsW, axis, knowedValuesW)
    [determinationCoefficientL, determinationCoefficientW]
  end
end
