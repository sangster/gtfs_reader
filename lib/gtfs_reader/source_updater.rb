# frozen_string_literal: true

require 'active_support/core_ext/object/try'
require 'csv'
require 'net/http'
require 'uri'
require 'zip/filesystem'

require_relative 'file_reader'

module GtfsReader
  # Downloads remote Feed files, checks that they are valid, and passes each
  # file in the feed to the handlers in the given [Source].
  class SourceUpdater
    # @param name [String] an arbitrary string describing this source
    # @param source [Source]
    def initialize(name, source)
      @name = name
      @source = source
      @temp_files = {}
    end

    # Call the "before" callback set on this source
    def before_callbacks
      @source.before&.call(fetch_data_set_identifier)
    end

    # Download the data from the remote server
    def download_source
      Log.debug { "         Reading #{@source.location.green}" }
      zip = open_temporary_zip
      extract_to_tempfiles(zip)
      Log.debug { "Finished reading #{@source.location.green}" }
    rescue StandardError => e
      Log.error(e.message)
      raise e
    ensure
      zip.try(:close)
    end

    def close
      @temp_files.values.each(&:close)
    end

    # Parse the filenames in the feed and check which required and optional
    # files are present.
    # @raise [RequiredFilenamesMissing] if the feed is missing a file which is
    #  marked as "required" in the [FeedDefinition]
    def check_files
      @found_files = []
      check_required_files
      check_optional_files
      # Add feed files of zip to the list of files to be processed
      @source.feed_definition.files.each do |req|
        @found_files << req if filenames.include?(req.filename)
      end
    end

    # Check that every file has its required columns
    def check_columns
      @found_files.each do |file|
        @temp_files[file.filename].open do |data|
          FileReader.new(data, file, validate: true)
        end
      end
    end

    def process_files
      @found_files.each do |file|
        if @source.handlers.handler?(file.name)
          process_from_temp_file(file)
        else
          Log.warn { "Skipping #{file.filename.yellow} (no handler)" }
        end
      end
    end

    private

    def open_temporary_zip
      zip = Tempfile.new('gtfs')
      zip.binmode
      zip << read_source
      zip.rewind
      zip
    end

    def read_source
      if @source.path
        File.read(@source.path)
      elsif @source.url
        http_get(@source.url)
      else
        raise SourceDefinitionError 'Must specify path or url'
      end
    end

    def http_get(uri_str, redirect_limit: 5)
      raise HttpError, 'HTTP redirect too deep' if redirect_limit.zero?

      case http_response(URI.parse(uri_str))
      when Net::HTTPSuccess
        response.body
      when Net::HTTPRedirection
        new_url = URI.join(url, response['location'])
        http_get(new_url.to_s, redirect_limit: redirect_limit - 1)
      else
        response.error!
      end
    end

    def http_response(url)
      use_ssl = url.scheme == 'https'
      req = Net::HTTP::Get.new(url.path)

      Net::HTTP.start(url.host, url.port, use_ssl:) do |http|
        http.request(req)
      end
    end

    def extract_to_tempfiles(zip)
      Zip::File.open(zip).each do |entry|
        temp = Tempfile.new("gtfs_file_#{entry.name}")
        temp.binmode
        temp << entry.get_input_stream.read
        temp.close
        @temp_files[entry.name] = temp
      end
    end

    # Check for the given list of expected filenames in the zip file
    def check_missing_files(expected, found_color, missing_color)
      check = '✔'.colorize(found_color)
      cross = '✘'.colorize(missing_color)

      expected.map do |req|
        filename = req.filename
        if filenames.include?(filename)
          Log.info { "#{filename.rjust(filename_width)} [#{check}]" }
          nil
        else
          Log.info { "#{filename.rjust(filename_width)} [#{cross}]" }
          filename
        end
      end.compact
    end

    # @return <FixNum> the maximum string-width of the filenames, so they can be
    #  aligned when printed on the console.
    def filename_width
      @filename_width ||= @source.feed_definition.files.max do |a, b|
        a.filename.length <=> b.filename.length
      end.filename.length
    end

    def filenames
      @temp_files.keys
    end

    # @return [String] A unique identifier for the remote data set.
    def fetch_data_set_identifier
      if @source.url
        fetch_data_set_identifier_from_url
      else
        fetch_data_set_identifier_from_path
      end
    end

    # @note This will choose a header from the result in the given order of
    #   preference:
    #   - ETag
    #   - Last-Modified
    #   - Content-Length (may result in different data sets being considered
    #     the same if they happen to have the same size)
    #   - The current date/time (this will always result in a fresh download)
    def fetch_data_set_identifier_from_url
      uri = URI(@source.url)
      Net::HTTP.start(uri.host) do |http|
        head_request = http.request_head(uri.path)
        if head_request.key?('etag')
          head_request['etag']
        else
          Log.warn("No ETag supplied with: #{uri.path}")
          fetch_http_fallback_identifier(head_request)
        end
      end
    end

    def fetch_data_set_identifier_from_path
      [@source.path, File.mtime(@source.path)].join('-')
    rescue StandardError => e
      Log.error(e)
      raise
    end

    # Find a "next best" ID when the HEAD request does not return an "ETag"
    # header.
    def fetch_http_fallback_identifier(head_request)
      if head_request.key?('last-modified')
        head_request['last-modified']
      elsif head_request.key?('content-length')
        head_request['content-length']
      else
        Time.now.to_s
      end
    end

    def process_from_temp_file(file)
      do_parse = !GtfsReader.config.skip_parsing
      hash = GtfsReader.config.return_hashes

      Log.info("Reading file #{file.filename.cyan}...")
      reader = FileReader.new(@temp_files[file.filename], file,
                              parse: do_parse, hash:)
      @source.handlers.handle_file(file.name, reader)
    end

    # @raise [RequiredFilenamesMissing] if a file is missing a header which is
    #  marked as "required" in the [FeedDefinition]
    def check_required_files
      Log.info { 'required files'.magenta }
      files = @source.feed_definition.required_files
      missing = check_missing_files(files, :green, :red)
      raise RequiredFilenamesMissing, missing unless missing.empty?
    end

    def check_optional_files
      Log.info { 'optional files'.cyan }
      files = @source.feed_definition.optional_files
      check_missing_files(files, :cyan, :light_yellow)
    end
  end
end
