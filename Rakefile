# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'rake'
require 'juwelier'
require 'rubocop/rake_task'

require_relative 'lib/gtfs_reader'
require_relative 'lib/gtfs_reader/version'

begin
  Bundler.setup :default, :development
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

Juwelier::Tasks.new do |gem|
  gem.name = 'gtfs_reader'
  gem.version = GtfsReader::Version.to_s
  gem.homepage = 'http://github.com/sangster/gtfs_reader'
  gem.license = 'GPL-3.0'
  gem.summary = 'Read General Transit Feed Specification zip files'
  gem.description = <<-DESC.strip.gsub(/\s+/, ' ')
    Reads and parses zip files conforming to Google's GTFS spec. Such files can
    take up quite a bit of memory when inflated, so this gem prefers to read
    them as a stream of rows.

    GTFS Spec: https://developers.google.com/transit/gtfs
  DESC
  gem.email = 'jon@ertt.ca'
  gem.authors = ['Jon Sangster']

  gem.files = Dir['{lib}/**/*', 'Rakefile', '*.md', 'LICENSE']
end

Juwelier::RubygemsDotOrgTasks.new

task :pry do
  exec 'pry --gem'
end

task bump: ['bump:patch']
namespace :bump do
  %i[major minor patch].each do |part|
    bumper = GtfsReader::Version::Bumper.new part
    desc "Bump the version to #{bumper}"
    task(part) { bumper.bump }
  end
end

# RSpec
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task default: :spec

namespace :lint do
  RuboCop::RakeTask.new do |task|
    task.requires << 'rubocop-rspec'
  end
end

desc 'Run all linters'
task lint: ['lint:rubocop']
