require "matrix"

module LinearRegressionHelper
  def getRegressionResult(inputs)
    arrayOfInputs = [inputs[:lux], inputs[:n_fish], inputs[:ph], inputs[:temperature], inputs[:water_flow], inputs[:previous_length], inputs[:previous_width]].map(&:to_f)

    result = Hash.new

    axis = getAxis
    knowedValuesL = getKnowedGrowthLength
    knowedValuesW = getKnowedGrowthWidth

    constantsL = getConstants(axis, knowedValuesL)
    result[:constantsL] = constantsL.column(0)
    result[:expectedGrowthLength] = calcGrowth(constantsL, arrayOfInputs)

    constantsW = getConstants(axis, knowedValuesW)
    result[:constantsW] = constantsW.column(0)
    result[:expectedGrowthWidth] = calcGrowth(constantsW, arrayOfInputs)

    errorsL = calcErrors(constantsL, axis, knowedValuesL)
    result[:errorMinL] = errorsL.min
    result[:errorMaxL] = errorsL.max

    errorsW = calcErrors(constantsW, axis, knowedValuesW)
    result[:errorMinW] = errorsW.min
    result[:errorMaxW] = errorsW.max

    result[:coefficientL] = calcDeterminationCoefficient(constantsL, axis, knowedValuesL)
    result[:coefficientW] = calcDeterminationCoefficient(constantsW, axis, knowedValuesW)

    result[:sizeGraphLength] = [result[:expectedGrowthLength] + inputs[:previous_length].to_f]
    result[:sizeGraphWidth] = [result[:expectedGrowthWidth] + inputs[:previous_width].to_f]

    def inputsAux(inputs, length, width)
      [inputs[:lux], inputs[:n_fish], inputs[:ph], inputs[:temperature], inputs[:water_flow], length, width].map(&:to_f)
    end

    6.times {
      oldLength = result[:sizeGraphLength].last
      oldWidth = result[:sizeGraphWidth].last
      result[:sizeGraphLength] << calcGrowth(constantsL, inputsAux(inputs, oldLength, oldWidth)) + oldLength
      result[:sizeGraphWidth]  << calcGrowth(constantsW, inputsAux(inputs, oldLength, oldWidth)) + oldWidth
    }

    result
  end

  def calcGrowth(constants, variables)
    results = constants.map.with_index { |b, i| b * variables[i] }
    results.inject(0, &:+)
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

  def calcErrors(constants, axis, knowedValues)
    axis.row_vectors.map.with_index do |vector, i|
      calcSingleError(constants, vector, knowedValues.row(i).first)
    end
  end

  def calcSquareErrors(constants, axis, knowedValues)
    calcErrors(constants, axis, knowedValues).map { |e| e ** 2 }
  end

  # As closer to 1, more precise the linear regression prediction
  def calcDeterminationCoefficient(constants, axis, knowedValues)
    media = knowedValues.inject(0, &:+)/knowedValues.count
    sse = calcSquareErrors(constants, axis, knowedValues).inject(0, &:+)
    sst = knowedValues.map{|x| (x - media)**2}.inject(0, &:+)
    ssr = sst - sse
    ssr/sst
  end
end
