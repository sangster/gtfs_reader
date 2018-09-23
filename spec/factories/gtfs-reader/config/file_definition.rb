FactoryBot.define do
  factory :file_definition, class: GtfsReader::Config::FileDefinition do
    initialize_with { new name, opts }

    opts { {} }
    sequence(:name) { |n| "file_definition: 'file_#{n}'" }
  end
end
