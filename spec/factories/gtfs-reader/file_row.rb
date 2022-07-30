# frozen_string_literal: true

FactoryBot.define do
  factory :file_row, class: GtfsReader::FileRow do
    sequence :line_number, 1000
    headers { build :file_row_headers }
    data { build :file_row_data }
    definition { build :file_row_definition }
    do_parse { true }

    initialize_with { new line_number, headers, data, definition, do_parse }
  end

  factory :file_row_headers, class: Hash do
    initialize_with { %i[ha hb hc hd he] }
  end

  factory :file_row_data, class: Hash do
    sequence(:a) { |n| 'a' * n }
    sequence(:b) { |n| 'b' * n }
    sequence(:c) { |n| 'c' * n }
    sequence(:d) { |n| 'd' * n }
    sequence(:e) { |n| 'e' * n }
    initialize_with { { ha: a, hb: b, hc: c, hd: d, he: e } }
  end

  factory :file_row_definition, class: GtfsReader::Config::FileDefinition do
    initialize_with do
      build(:file_definition).tap do |fd|
        fd.col :ha
        fd.col :hb
        fd.col :hc
        fd.col :hd
        fd.col :he
      end
    end
  end
end
