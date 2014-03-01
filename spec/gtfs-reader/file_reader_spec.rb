require 'spec_helper'

describe GtfsReader::FileReader do
  let( :definition ) do
    GtfsReader::Config::FileDefinition.new('test_file').tap do |file_def|
      file_def.instance_eval( &columns )
    end
  end
  let( :columns ) { Proc.new { ha and hb required: true } }
  let( :data ) { "ha,hb\n1a,1b" }

  describe :new do
    subject { GtfsReader::FileReader }

    context 'with a required column' do
      context 'with good data' do
        let( :data ) { "ha,hb\n1a,1b" }
        it { expect{ subject.new data, definition }.not_to raise_exception }
      end

      context 'with bad data' do
        let( :data ) { "ha,bad_col\n1a,1b" }
        it { expect{ subject.new data, definition }.
          to raise_exception GtfsReader::RequiredHeaderMissing }
      end
    end
  end

  describe :columns do
    subject( :reader ) { GtfsReader::FileReader.new data, definition }
    it { expect( its( :columns, :keys ) ).to eq [:ha, :hb] }
    it { expect( its( :columns )[:hb] ).to be_required }
  end
end
