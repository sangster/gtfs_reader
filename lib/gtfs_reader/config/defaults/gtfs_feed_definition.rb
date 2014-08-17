require_relative '../feed_definition'

module GtfsReader
  module Config
    module Defaults
      FEED_DEFINITION = FeedDefinition.new.tap do |feed|
        feed.instance_exec do
          file :agency, required: true do
            col :agency_name,     required: true
            col :agency_url,      required: true
            col :agency_timezone, required: true
            col :agency_id,                       unique: true
            col :agency_lang
            col :agency_phone
            col :agency_fare_url
          end

          file :stops, required: true do
            col :stop_id,       required: true, unique: true
            col :stop_code
            col :stop_name,     required: true
            col :stop_desc
            col :stop_lat,      required: true
            col :stop_lon,      required: true
            col :stop_url
            col :stop_timezone
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
            col :route_id,         required: true, unique: true
            col :route_short_name, required: true
            col :route_long_name,  required: true
            col :route_desc
            col :route_type,       required: true,
                &output_map(   :unknown,
                               tram: ?0,
                               subway: ?1,
                               rail: ?2,
                               bus: ?3,
                               ferry: ?4,
                               cable_car: ?5,
                               gondola: ?6,
                               funicular: ?7 )
            col :route_url
            col :route_color
            col :route_text_color
            col :agency_id
          end

          file :trips, required: true do
            col :trip_id,               required: true, unique: true
            col :trip_headsign
            col :trip_short_name
            col :trip_long_name
            col :route_id,              required: true
            col :service_id,            required: true
            col :direction_id,          &output_map( primary: ?0, opposite: ?1 )
            col :block_id
            col :shape_id
            col :wheelchair_accessible, &output_map( :unknown, yes: ?1, no: ?2 )
            col :bikes_allowed,         &output_map( :unknown, yes: ?1, no: ?2 )
          end

          file :stop_times, required: true do
            col :trip_id,        required: true
            col :arrival_time,   required: true
            col :departure_time, required: true
            col :stop_id,        required: true
            col :stop_sequence,  required: true
            col :stop_headsign

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
            col :monday,     required: true, &output_map( yes: ?1, no: ?0 )
            col :tuesday,    required: true, &output_map( yes: ?1, no: ?0 )
            col :wednesday,  required: true, &output_map( yes: ?1, no: ?0 )
            col :thursday,   required: true, &output_map( yes: ?1, no: ?0 )
            col :friday,     required: true, &output_map( yes: ?1, no: ?0 )
            col :saturday,   required: true, &output_map( yes: ?1, no: ?0 )
            col :sunday,     required: true, &output_map( yes: ?1, no: ?0 )
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
            col :shape_id,            required: true
            col :shape_pt_lat,        required: true
            col :shape_pt_lon,        required: true
            col :shape_pt_sequence,   required: true
            col :shape_dist_traveled
          end

          file :frequencies do
            col :trip_id,      required: true
            col :start_time,   required: true
            col :end_time,     required: true
            col :headway_secs, required: true
            col :exact_times,  &output_map( :inexact, exact: 1 )
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
            col :feed_publisher_name, required: true
            col :feed_publisher_url,  required: true
            col :feed_lang,           required: true
            col :feed_start_date
            col :feed_end_date
            col :feed_version
          end
        end
      end
    end
  end
end
