require 'rails_helper'

RSpec.describe CsvImporter do
  let(:csv_content) do
    <<~CSV
      Name,Location,Species,Gender,Affiliations,Weapon,Vehicle
      Darth Vadar,"Death Star, Tatooine",Human,Male,Sith,Lightsaber,Tiefighter
      Chewbacca,kashyyk,Wookie,m,Rebel Alliance,Bowcaster,Millennium Falcon
      yoda,Yoda's Hutt,Unknown,Male,Jedi Order,Lightsaber,
      Jar Jar Binks,Naboo,Gungan,Male,Galactic Republic,Energy Bola,
      Boba Fett,Kamino,Human,Male,,Blaster Rifle,Slave I
    CSV
  end

  let(:file) do
    Tempfile.new(['users', '.csv']).tap do |f|
      f.write(csv_content)
      f.rewind
    end
  end

  subject { described_class.new(file).call }

  after { file.unlink }

  describe '#call' do
    it 'imports valid records' do
      result = subject
      puts "Importer Result: #{result.inspect}" if result.imported_count != 4
      expect(result.imported_count).to eq(4)
    end

    it 'skips rows with empty Affiliations (Boba Fett)' do
      subject
      expect(Person.find_by(first_name: 'Boba', last_name: 'Fett')).to be_nil
    end

    it 'titleizes names' do
      subject
      yoda = Person.find_by(first_name: 'Yoda')
      expect(yoda).to be_present
      expect(yoda.full_name).to eq('Yoda')
    end

    it 'titleizes locations' do
      subject
      chewie = Person.find_by(first_name: 'Chewbacca')
      expect(chewie.locations.pluck(:name)).to include('Kashyyk')
    end

    it 'ignores Species and Gender columns' do
      subject
      expect(Person.new).not_to respond_to(:species)
      expect(Person.new).not_to respond_to(:gender)
    end

    it 'handles multi-word first names correctly (Jar Jar Binks)' do
      subject
      jar_jar = Person.find_by(last_name: 'Binks')
      expect(jar_jar).to be_present
      expect(jar_jar.first_name).to eq('Jar Jar')
      expect(jar_jar.last_name).to eq('Binks')
      expect(jar_jar.full_name).to eq('Jar Jar Binks')
    end
  end
end
