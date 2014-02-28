module GtfsReader::Config::Defaults
  Moo = Proc.new do
    agency required: true do
      prefix :agency do
        name required: true
        url required: true
        timezone required: true
        id unique: true
        lang
        phone
        fare_url
      end
    end

    stops required: true do
      prefix :stop do
        id required: true, unique: true
        code
        name required: true
        desc
        lat required: true
        lon required: true
        url
        timezone
      end

      zone_id
      location_type &output_map( :stop, station: ?1 )
      parent_station
      wheelchair_boarding do |val|
        if parent_station
          case val
            when ?2 then :no
            when ?1 then :yes
            else :inherit
          end
        else
          case val
            when ?2 then :no_vehicles
            when ?1 then :some_vehicles
            else :unknown
          end
        end
      end
    end

    routes required: true do
      prefix :route do
        id required: true, unique: true
        short_name required: true
        long_name required: true
        desc
        type required: true, &output_map( :unknown,
          tram: ?0, subway: ?1, rail: ?2, bus: ?3, ferry: ?4, cable_car: ?5,
          gondola: ?6, funicular: ?7 )
        url
        color
        text_color
      end

      agency_id
    end

    trips required: true do
      prefix :trip do
        id required: true, unique: true
        headsign
        short_name
        long_name
      end

      route_id required: true
      service_id required: true
      direction_id &output_map( primary: ?0, opposite: ?1 )
      block_id
      shape_id
      wheelchair_accessible &output_map( :unknown, yes: ?1, no: ?2 )
      bikes_allowed &output_map( :unknown, yes: ?1, no: ?2 )
    end

    stop_times required: true do
      trip_id required: true
      arrival_time required: true
      departure_time required: true

      prefix :stop do
        id required: true
        sequence required: true
        headsign
      end

      pickup_type &output_map( :regular,
        none: ?1, phone_agency: ?2, coordinate_with_driver: ?3 )
      drop_off_type &output_map( :regular,
        none: ?1, phone_agency: ?2, coordinate_with_driver: ?3 )

      shape_dist_traveled
    end

    calendar required: true do
      service_id required: true, unique: true

      monday required: true, &output_map( yes: ?1, no: ?0 )
      tuesday required: true, &output_map( yes: ?1, no: ?0 )
      wednesday required: true, &output_map( yes: ?1, no: ?0 )
      thursday required: true, &output_map( yes: ?1, no: ?0 )
      friday required: true, &output_map( yes: ?1, no: ?0 )
      sunday required: true, &output_map( yes: ?1, no: ?0 )

      start_date
      end_date
    end

    calendar_dates do
      service_id required: true
      date required: true
      exception_type required: true, &output_map( added: ?1, removed: ?2 )
    end
  end
end
