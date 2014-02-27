FactoryGirl.define do
  factory :file_format, class: GtfsReader::Config::FileFormat do
    initialize_with { new name, opts }

    opts { Hash.new }
    sequence(:name) {|n| "file_format: 'file_#{n}'"}
  end
end
