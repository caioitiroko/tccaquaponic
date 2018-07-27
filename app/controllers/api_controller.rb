class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:grow_bed_datum, :grow_bed_data]

  def grow_bed_data
    begin
      data = request.body.read
      all_data = JSON.parse(data, object_class: Array)
      all_data.map { |datum|
        if datum_op = OpenStruct.new(JSON.parse(datum))
          if grow_bed = GrowBed.find(datum_op.grow_bed_id)
            grow_bed_datum = grow_bed.grow_bed_data.find_or_initialize_by(date: datum_op.date) if datum_op.date

            grow_bed_datum.avg_width = '%.1f' % datum_op.avg_width
            grow_bed_datum.avg_length = '%.1f' % datum_op.avg_length
            grow_bed_datum.temperature = '%.1f' % datum_op.temperature
            grow_bed_datum.water_flow = datum_op.water_flow
            grow_bed_datum.lux = '%.1f' % datum_op.lux
            grow_bed_datum.ph = '%.1f' % datum_op.ph
            grow_bed_datum.n_fish = datum_op.n_fish
            grow_bed_datum.grow_bed = grow_bed

            grow_bed_datum.save!
          end
        end
      }
      head :ok
    rescue => ex
      logger.error ex.message
      head :internal_server_error
    end
  end

  def grow_bed_datum
    begin
      if data = OpenStruct.new(JSON.parse(request.body.read))
        if grow_bed = GrowBed.find(data.grow_bed_id)
          grow_bed_datum = grow_bed.grow_bed_data.find_or_initialize_by(date: data.date) if data.date

          grow_bed_datum.avg_width = '%.1f' % datum_op.avg_width
          grow_bed_datum.avg_length = '%.1f' % datum_op.avg_length
          grow_bed_datum.temperature = '%.1f' % datum_op.temperature
          grow_bed_datum.water_flow = datum_op.water_flow
          grow_bed_datum.lux = '%.1f' % datum_op.lux
          grow_bed_datum.ph = '%.1f' % datum_op.ph
          grow_bed_datum.n_fish = datum_op.n_fish
          grow_bed_datum.grow_bed = grow_bed

          grow_bed_datum.save!
        end
        head :ok
      end
    rescue => ex
      logger.error ex.message
      head :internal_server_error
    end
  end

  def last_datum
    begin
      grow_bed_id = params[:grow_bed_id]
      grow_bed = GrowBed.find(grow_bed_id)
      grow_bed_datum = grow_bed.grow_bed_data.order(date: :desc).first
      respond_to do |format|
         format.json { render :json => grow_bed_datum}
      end
    rescue => ex
      logger.error ex.message
      head :internal_server_error
    end
  end
end
