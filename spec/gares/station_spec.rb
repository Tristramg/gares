require 'spec_helper'

# This test uses "Lyon Part-Dieu" as a testing sample:
#
describe Gares::Station do

  describe 'valid gare' do

    subject do
      # Get gare de Lyon Part-Dieu
      Gares::Station.find_by_sncf_id('frlpd')
    end

    it 'should find the name' do
      expect(subject.name).to eql('Lyon Part-Dieu')
    end

    it 'should find the sncf_id' do
      expect(subject.sncf_id).to eql('FRLPD')
      # Still supports deprecated fields
      expect(subject.slug).to eql(subject.sncf_id.downcase)
    end

    it 'should find the TVS number' do
      expect(subject.send(:tvs)).to eql('LYD')
    end

    it 'should find the geolocation coordinates' do
      expect(subject.latitude).to eql(45.760568)
      expect(subject.longitude).to eql(4.859991)
      # Still supports deprecated fields
      expect(subject.lat).to eql(subject.latitude)
      expect(subject.long).to eql(subject.longitude)
    end

    it 'has a list of departure trains' do
      expect(subject.departures.size).to eq(20)
      expect(subject.departures.first.origdest.name).to eq('Bruxelles')
      expect(subject.departures.first.heure).to eq('05:50')
      expect(subject.departures.first.type).to eq('TGV')
    end

    it 'has a list of arrivals' do
      expect(subject.arrivals.last.origdest.name).to eq('Chambéry Challes-les-Eaux')
      expect(subject.arrivals.last.voie).to eq('')
      expect(subject.arrivals.last.platform).to eq(subject.arrivals.last.voie)
      expect(subject.arrivals.last.num).to eq(18542)
    end

    context 'Station of Agde' do
      subject do
        # Get gare de Agde
        Gares::Station.find_by_sncf_id('frxag')
      end

      describe 'a gare with a BLS' do
        it { expect(subject.has_borne?).to be(true) }
      end
    end
  end
end
