# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Add support for Ruby 3.
- `Source#path` now specifies a local GTFS zip file to read. This configuration
  is mutually exclusive with `Source#url`. Don't use both.
- Added example usages in `examples/` directory.
- Added RuboCop gem for linting ruby files.
- Added this CHANGELOG.
### Changed
- `Source#url` can no longer be used to load files from the local filesystem.
  Use `Source#path` instead.
### Removed
- Remove support for Ruby 2.
