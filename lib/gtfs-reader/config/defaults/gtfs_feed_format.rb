module GtfsReader::Config::Defaults
  Moo = Proc.new do
    agency required: true do
      agency_name required: true
      agency_url required: true
      agency_timezone required: true
      agency_id
      agency_lang
      agency_phone
      agency_fare_url
    end
  end
end
