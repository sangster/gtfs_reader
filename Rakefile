# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'rake'
require 'jeweler'

require File.dirname(__FILE__) + '/lib/gtfs_reader'

begin
  Bundler.setup :default, :development
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

Jeweler::Tasks.new do |gem|
  gem.name = 'gtfs-reader'
  gem.version = GtfsReader::Version.to_s
  gem.homepage = 'http://github.com/sangster/gtfs-reader'
  gem.license = 'Creative Commons Attribution-NonCommercial 4.0'
  gem.summary = 'Read General Transit Feed Specification zip files'
  gem.description = <<-EOF.strip.gsub /\s+/, ' '
    Reads and parses zip files conforming to Google's GTFS spec. Such files can
    take up quite a bit of memory when inflated, so this gem prefers to read
    them as a stream of rows.

    GTFS Spec: https://developers.google.com/transit/gtfs
  EOF
  gem.email = 'jon@ertt.ca'
  gem.authors = ['Jon Sangster']
end

Jeweler::RubygemsDotOrgTasks.new

task :default => :pry

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
