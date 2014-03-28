require 'gtfs_reader/config/handler_map'

describe GtfsReader::Config::HandlerMap do
  subject(:map) { GtfsReader::Config::HandlerMap.new }

  it{ expect( map.file(:filename) {}.class ).to be GtfsReader::Config::Handler }
  it{ expect( map.file(:filename) {} ).not_to be map.file(:filename) {} }
  it { expect{ map.file(:filename) {} }.to change{ map.handler? :filename }.
                                        from( false ).to true }

  context 'with a handler' do
    let(:handler_obj) { double 'handler' }
    let(:handler) do
      allow( handler_obj ).to receive :give
      Proc.new { |row| handler_obj.give row }
    end
    let(:row) { 'row' }
    before { map.file :filename, &handler }

    it do
      map.enum_for(:filename).first.call row
      expect( handler_obj ).to have_received( :give ).with row
    end
  end
end
