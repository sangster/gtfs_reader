module GtfsReader
  module Version
    MAJOR = 2
    MINOR = 0
    PATCH = 1
    BUILD = nil

    def self.to_s
      [MAJOR, MINOR, PATCH, BUILD].compact.join '.'
    end

    class Bumper
      PARTS = %i[major minor patch]
      PATTERN = %r[(\s+)MAJOR = (\d+)\n\s+MINOR = (\d+)\n\s+PATCH = (\d+)\n\s+BUILD = (.+)]

      def initialize(part)
        raise "#{part} not one of #{PARTS}" unless PARTS.include? part
        @part = part
      end

      def bump
        parts = {
            major: MAJOR,
            minor: MINOR,
            patch: PATCH,
            build: BUILD
        }.merge new_parts

        text = "\\1MAJOR = \\2\n\\1MINOR = \\3\n\\1PATCH = \\4\n\\1BUILD = \\5"

        out_data = File.read(__FILE__).gsub PATTERN, text
        File.open(__FILE__, 'w') { |out| out << out_data }
      end

      private

      def new_parts
        case @part
        when :major then {
            major: MAJOR + 1,
            minor: 0,
            patch: 0
        }
        when :minor then {
            minor: MINOR + 1,
            patch: 0
        }
        else {
            patch: PATCH + 1
        }
        end
      end
    end
  end
end
