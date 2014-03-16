module GtfsReader
  module Config
    module Defaults
      FEED_DEFINITION = Proc.new do
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

        fare_attributes do
          fare_id required: true, unique: true
          price required: true
          currency_type required: true
          payment_method required: true, &output_map( on_board: 0, before: 1 )
          transfers required: true, &output_map( :unlimited, none: 0, once: 1,
            twice: 2 )
          transfer_duration
        end

        fare_rules do
          fare_id required: true
          route_id
          origin_id
          destination_id
          contains_id
        end

        shapes do
          prefix :shape do
            id required: true
            pt_lat required: true
            pt_lon required: true
            pt_sequence required: true
            dist_traveled
          end
        end

        frequencies do
          trip_id required: true
          start_time required: true
          end_time required: true
          headway_secs required: true
          exact_times &output_map( :inexact, exact: 1 )
        end

        transfers do
          from_stop_id required: true
          to_stop_id required: true
          transfer_type required: true, &output_map( :recommended,
            timed_transfer: 1, minimum_time_required: 2, impossible: 3 )
          min_transfer_time
        end

        feed_info do
          prefix :scope do
            publisher_name required: true
            publisher_url required: true
            lang required: true
            start_date
            end_date
            version
          end
        end
      end
    end
  end
end
