# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup :default, :development
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "gtfs-reader"
  gem.homepage = "http://github.com/sangster/gtfs-reader"
  gem.license = "Creative Commons Attribution-NonCommercial 4.0"
  gem.summary = %Q{Read General Transit Feed Specification zip files}
  gem.description = <<-EOF.strip.gsub /\s+/, ' '
    Reads and parses zip files conforming to Google's GTFS spec. Such files can
    take up quite a bit of memory when inflated, so this gem prefers to read
    them as a stream of rows.

    GTFS Spec: https://developers.google.com/transit/gtfs
  EOF
  gem.email = "jon@ertt.ca"
  gem.authors = ["Jon Sangster"]
end

require './lib/gtfs-reader.rb'
Jeweler::Tasks.new do |gem|
  gem.version = GtfsReader::VERSION
end

Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new :test do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gtfs-reader #{version}"
  rdoc.rdoc_files.include 'README*'
  rdoc.rdoc_files.include 'lib/**/*.rb'
end


desc 'bump version number. V=[major,minor,patch,1.2.3]'
task :bump do |task|
  arg = ENV['V'] || 'patch'
  filename = "./lib/gtfs-reader.rb"
  pattern = /^  VERSION = '(.+)'$/

  unless %w{patch minor major}.include? arg or /\d+\.\d+\.\d+/.match arg
    $stderr.puts "unknown argument: #{arg}"
    exit 1
  end

  version = if /\d+\.\d+\.\d+/.match arg
    arg
  else
    version_line = File.open( filename ).find { |line| pattern.match line }
    major, minor, patch = pattern.match( version_line )[1].split(?.).collect &:to_i

    case arg
      when 'patch' then "#{major}.#{minor}.#{patch+1}"
      when 'minor' then "#{major}.#{minor+1}.0"
      when 'major' then "#{major+1}.0.0"
      else $stderr.puts "unknown argument: #{arg}" and exit 1
    end
  end

  out_data = File.read(filename).gsub pattern, "  VERSION = '#{version}'"
  File.open(filename, 'w') { |out| out << out_data }
end
