FactoryGirl.define do
  factory :column, class: GtfsReader::Config::Column do
    sequence(:name) { |n| "column_#{n}"}
    opts { Hash.new }
    initialize_with { new name, opts }
  end
end
