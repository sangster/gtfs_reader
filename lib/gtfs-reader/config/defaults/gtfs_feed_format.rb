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
              when '2' then :no
              when '1' then :yes
              else :inherit
            end
          else
            case val
              when '2' then :no_vehicles
              when '1' then :some_vehicles
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
          type required: true, &output_map( :unknown, funicular: ?7, gondola: ?6, cable_car: ?5,
                                            ferry: ?4, bus: ?3, rail: ?2, subway: ?1, tram: ?0 )
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
        direction_id
      end
    end
  end
end
