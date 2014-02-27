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
        location_type do |loc|
          case loc
            when '1' then :station
            else :stop 
          end
        end
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
          type required: true do |type|
            case type
              when '7' then :funicular
              when '6' then :gondola
              when '5' then :cable_car
              when '4' then :ferry
              when '3' then :bus
              when '2' then :rail
              when '1' then :subway
              when '0' then :tram
              else :unknown
            end
          end
          url
          color
          text_color
        end

        agency_id
      end
    end
  end
end
