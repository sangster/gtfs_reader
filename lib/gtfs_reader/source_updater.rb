require 'net/http'
require 'open-uri'
require 'zip/filesystem'
require 'csv'

module GtfsReader
  class SourceUpdater
    #@param name [String] an arbitrary string describing this source
    #@param source [Source]
    def initialize(name, source)
      @name, @source = name, source
    end

    # Download the data from the remote server
    def read
      Log.debug { "         Reading #{@source.url.green}" }
      @file = Tempfile.new 'metro_transit'
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
      check_required_files
      check_optional_files
    end

    def check_required_files
      Log.info { "Checking for #{'required files'.magenta}" }
      files = @source.feed_definition.required_files

      files.each do |req|
        filename = req.filename
        unless filenames.include? filename
          Log.info { "#{filename.rjust filename_width} [#{'✘'.red}]" }
          raise RequiredFilenameMissing,
            "Required file '#{filename}' missing from zip file"
        end
        Log.info { "#{filename.rjust filename_width} [#{'✔'.green}]" }
      end
    end

    def check_optional_files
      Log.info { "Checking for #{'optional files'.cyan}" }
      files = @source.feed_definition.optional_files

      files.each do |req|
        filename = req.filename
        if filenames.include? filename
          Log.info { "#{filename.rjust filename_width} [#{'✔'.cyan}]" }
        else
          Log.info { "#{filename.rjust filename_width} [#{'✘'.light_yellow}]" }
        end
      end
    end

    private

    def filename_width
      @filename_length ||= @source.feed_definition.files.max do |a, b|
        a.filename.length <=> b.filename.length
      end.filename.length
    end

    def filenames
      @filenames ||= @zip.entries.collect &:name
    end

    def fetch_remote_etag(url)
      Net::HTTP.start(url.host) { |http| http.request_head(url.path)['etag'] }
    end
  end
end
