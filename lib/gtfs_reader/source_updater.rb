require 'net/http'
require 'open-uri'
require 'zip/filesystem'
require 'csv'
require 'uri'

require_relative 'file_reader'

module GtfsReader
  class SourceUpdater
    #@param name [String] an arbitrary string describing this source
    #@param source [Source]
    def initialize(name, source)
      @name, @source = name, source
      @temp_files = {}
    end

    def before_callbacks
      @source.before.call fetch_data_set_identifier if @source.before
    end

    # Download the data from the remote server
    def read
      Log.debug { "         Reading #{@source.url.green}" }
      extract_zip_to_tempfiles
      Log.debug { "Finished reading #{@source.url.green}" }
    end

    def extract_zip_to_tempfiles
      file = Tempfile.new 'gtfs'
      file.binmode
      file << open(@source.url).read
      file.rewind

      Zip::File.open(file).each do |entry|
        temp = Tempfile.new "gtfs_file_#{entry.name}"
        temp << entry.get_input_stream.read
        temp.close
        @temp_files[entry.name] = temp
      end

      file.close
    end

    def close
      @temp_files.values.each &:close
    end

    def check_files
      @found_files = []
      check_required_files
      check_optional_files
    end

    def check_required_files
      Log.info { 'required files'.magenta }
      files = @source.feed_definition.required_files
      missing = check_missing_files files, :green, :red
      raise RequiredFilenamesMissing, missing unless missing.empty?
    end

    def check_optional_files
      Log.info { 'optional files'.cyan }
      files = @source.feed_definition.optional_files
      check_missing_files files, :cyan, :light_yellow
    end

    # Check that every file has its required columns
    def check_columns
      @found_files.each do |file|
        @temp_files[file.filename].open do |data|
          FileReader.new data, file, validate: true
        end
      end
    end

    def process_files
      @found_files.each do |file|
        if @source.handlers.handler? file.name
          process_from_temp_file file
        else
          Log.warn { "Skipping #{file.filename.yellow} (no handler)" }
        end
      end
    end

    private

    # Checks for the given list of expected filenames in the zip file
    def check_missing_files(expected, found_color, missing_color)
      check = '✔'.colorize found_color
      cross = '✘'.colorize missing_color

      expected.map do |req|
        filename = req.filename
        if filenames.include? filename
          Log.info { "#{filename.rjust filename_width} [#{check}]" }
          @found_files << req
          nil
        else
          Log.info { "#{filename.rjust filename_width} [#{cross}]" }
          filename
        end
      end.compact
    end

    def filename_width
      @filename_width ||= @source.feed_definition.files.max do |a, b|
        a.filename.length <=> b.filename.length
      end.filename.length
    end

    def filenames
      @temp_files.keys
    end

    # Performs a HEAD request against the source's URL, in an attempt to
    # return a unique identifier for the remote data set. It will choose a
    # header from the result in the given order of preference:
    # - ETag
    # - Last-Modified
    # - Content-Length (may result in different data sets being considered
    #   the same if they happen to have the same size)
    # - The current date/time (this will always result in a fresh download)
    def fetch_data_set_identifier
      uri = URI @source.url
      Net::HTTP.start(uri.host) do |http|
        head_request = http.request_head uri.path
        if head_request.key? 'etag'
          head_request['etag']
        else
          Log.warn "No ETag supplied with: #{uri.path}"

          if head_request.key? 'last-modified'
            head_request['last-modified']
          elsif head_request.key? 'content-length'
            head_request['content-length']
          else
            Time.now.to_s
          end
        end
      end
    end

    def process_from_temp_file(file)
      do_parse = !GtfsReader.config.skip_parsing
      hash = !!GtfsReader.config.return_hashes

      Log.info "Reading file #{file.filename.cyan}..."
      begin
        reader = FileReader.new @temp_files[file.filename], file,
                                parse: do_parse, hash: hash
        @source.handlers.handle_file file.name, reader
      end
    end
  end
end
