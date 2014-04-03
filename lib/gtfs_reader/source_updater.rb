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
    end

    def before_callbacks
      @source.before.call fetch_remote_etag if @source.before
    end

    # Download the data from the remote server
    def read
      Log.debug { "         Reading #{@source.url.green}" }
      @file = Tempfile.new 'gtfs'
      @file.binmode
      @file << open(@source.url).read
      @zip = Zip::File.open @file
      Log.debug { "Finished reading #{@source.url.green}" }
    end

    # Close any streams still open
    def finish
      @zip.close if @zip
      @file.delete if @file
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
        @zip.file.open(file.filename) do |data|
          FileReader.new data, file, validate: true
        end
      end
    end

    def process_files
      do_parse = !GtfsReader.config.skip_parsing
      hash = !!GtfsReader.config.return_hashes

      @found_files.each do |file|
        Log.info "Reading file #{file.filename.cyan}..."

        temp = Tempfile.new 'gtfs_file'
        begin
          @zip.file.open(file.filename) { |z| temp.write z.read }
          temp.rewind
          reader = FileReader.new temp, file, parse: do_parse, hash: hash
          @source.handlers.handle_file file.name, reader
        ensure
          temp.close and temp.unlink
        end
      end
    end

    private

    def check_missing_files(expected, found_color, missing_color)
      check = '✔'.colorize found_color
      cross = '✘'.colorize missing_color

      expected.collect do |req|
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
      @filenames ||= @zip.entries.collect &:name
    end

    def fetch_remote_etag
      url = URI @source.url
      Net::HTTP.start(url.host) do |http|
        /[^"]+/ === http.request_head(url.path)['etag'] and $&
      end
    end
  end
end
