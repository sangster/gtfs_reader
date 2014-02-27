require 'spec_helper'

describe GtfsReader::Config::ArchiveFormat do
  subject(:format) { build :archive_format }

  it { expect( format.respond_to? :any_method_name_here ).to be_truthy }
  it { expect( its :undefined_table ).to be_nil }
  it { expect{ format.new_table {} }.to change{ its :new_table } }
end
