require_relative '../feed_definition'

module GtfsReader
  module Config
    module Defaults
      FEED_DEFINITION = FeedDefinition.new.tap do |feed|
        feed.instance_exec do
          file :agency, required: true do
            prefix :agency do
              col :name,     required: true
              col :url,      required: true
              col :timezone, required: true
              col :id,                       unique: true
              col :lang
              col :phone
              col :fare_url
            end
          end

          file :stops, required: true do
            prefix :stop do
              col :id,       required: true, unique: true
              col :code
              col :name,     required: true
              col :desc
              col :lat,      required: true
              col :lon,      required: true
              col :url
              col :timezone
            end

            col :zone_id
            col :location_type, &output_map( :stop, station: ?1 )
            col :parent_station

            col :wheelchair_boarding do |val|
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

          file :routes, required: true do
            prefix :route do
              col :id,         required: true, unique: true
              col :short_name, required: true
              col :long_name,  required: true
              col :desc
              col :type,       required: true,
                &output_map(   :unknown,
                                   tram: ?0,
                                 subway: ?1,
                                   rail: ?2,
                                    bus: ?3,
                                  ferry: ?4,
                              cable_car: ?5,
                                gondola: ?6,
                              funicular: ?7 )
              col :url
              col :color
              col :text_color
            end

            col :agency_id
          end

          file :trips, required: true do
            prefix :trip do
              col :id,         required: true, unique: true
              col :headsign
              col :short_name
              col :long_name
            end

            col :route_id,              required: true
            col :service_id,            required: true
            col :direction_id,
              &output_map( primary: ?0, opposite: ?1 )
            col :block_id
            col :shape_id
            col :wheelchair_accessible,
              &output_map( :unknown, yes: ?1, no: ?2 )
            col :bikes_allowed,
              &output_map( :unknown, yes: ?1, no: ?2 )
          end

          file :stop_times, required: true do
            col :trip_id,        required: true
            col :arrival_time,   required: true
            col :departure_time, required: true

            prefix :stop do
              col :id,       required: true
              col :sequence, required: true
              col :headsign
            end

            col :pickup_type,
              &output_map(    :regular,
                                  none: ?1,
                          phone_agency: ?2,
                coordinate_with_driver: ?3 )

            col :drop_off_type,
              &output_map(    :regular,
                                  none: ?1,
                          phone_agency: ?2,
                coordinate_with_driver: ?3 )

            col :shape_dist_traveled
          end

          file :calendar, required: true do
            col :service_id, required: true, unique: true

            col :monday,    required: true, &output_map( yes: ?1, no: ?0 )
            col :tuesday,   required: true, &output_map( yes: ?1, no: ?0 )
            col :wednesday, required: true, &output_map( yes: ?1, no: ?0 )
            col :thursday,  required: true, &output_map( yes: ?1, no: ?0 )
            col :friday,    required: true, &output_map( yes: ?1, no: ?0 )
            col :sunday,    required: true, &output_map( yes: ?1, no: ?0 )

            col :start_date
            col :end_date
          end

          file :calendar_dates do
            col :service_id,     required: true
            col :date,           required: true
            col :exception_type, required: true,
              &output_map( added: ?1, removed: ?2 )
          end

          file :fare_attributes do
            col :fare_id,        required: true, unique: true
            col :price,          required: true
            col :currency_type,  required: true
            col :payment_method, required: true,
              &output_map( on_board: 0, before: 1 )
            col :transfers,      required: true,
              &output_map( :unlimited, none: 0, once: 1, twice: 2 )
            col :transfer_duration
          end

          file :fare_rules do
            col :fare_id,        required: true
            col :route_id
            col :origin_id
            col :destination_id
            col :contains_id
          end

          file :shapes do
            prefix :shape do
              col :id,            required: true
              col :pt_lat,        required: true
              col :pt_lon,        required: true
              col :pt_sequence,   required: true
              col :dist_traveled
            end
          end

          file :frequencies do
            col :trip_id,      required: true
            col :start_time,   required: true
            col :end_time,     required: true
            col :headway_secs, required: true
            col :exact_times,
              &output_map( :inexact, exact: 1 )
          end

          file :transfers do
            col :from_stop_id,      required: true
            col :to_stop_id,        required: true
            col :transfer_type,     required: true,
              &output_map( :recommended,
                         timed_transfer: 1,
                  minimum_time_required: 2,
                             impossible: 3 )
            col :min_transfer_time
          end

          file :feed_info do
            prefix :scope do
              col :publisher_name, required: true
              col :publisher_url,  required: true
              col :lang,           required: true
              col :start_date
              col :end_date
              col :version
            end
          end
        end
      end
    end
  end
end
