# frozen_string_literal: true

FactoryBot.define do
  factory :column, class: GtfsReader::Config::Column do
    sequence(:name) { |n| "column_#{n}" }
    opts { {} }
    initialize_with { new name, opts }
  end
end
