FactoryGirl.define do
  factory :feed_definition, class: GtfsReader::Config::FeedDefinition do
    ignore do
      definition( Proc.new do
        routes { col_1 ; col_2 required: true }
        trips { col_1 ; col_2 optional: true }
      end )
    end

    after( :build ) {|f,e| f.instance_eval &e.definition if e.definition }
  end
end
