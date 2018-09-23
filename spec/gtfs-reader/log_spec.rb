describe GtfsReader::Log do
  subject(:log) { GtfsReader::Log }

  before { subject.logger { nil } }

  it { expect(subject.logger { nil }).not_to be_nil }

  describe 'log levels' do
    before { subject.tap { |log| log.logger { logger } } }
    let(:logger) { double 'logger' }
    let(:args) { %i[a b c] }

    describe :debug do
      it { expect(logger).to(receive(:debug).with(*args)) && log.debug(*args) }
    end
    describe :info do
      it { expect(logger).to(receive(:info).with(*args)) && log.info(*args) }
    end
    describe :warn do
      it { expect(logger).to(receive(:warn).with(*args)) && log.warn(*args) }
    end
    describe :error do
      it { expect(logger).to(receive(:error).with(*args)) && log.error(*args) }
    end
    describe :fatal do
      it { expect(logger).to(receive(:fatal).with(*args)) && log.fatal(*args) }
    end
  end

  describe :level do
    it { expect { log.level = :debug }.to(change { its :level }) }
    it { expect { log.level = :warn  }.to(change { its :level }) }
    it { expect { log.level = :error }.to(change { its :level }) }
    it { expect { log.level = :fatal }.to(change { its :level }) }
    it { expect { log.level = :snake }.to raise_error(RuntimeError) }
  end
end
