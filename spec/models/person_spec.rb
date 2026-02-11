# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:locations) }
    it { should have_and_belong_to_many(:affiliations) }
  end

  describe '#full_name' do
    it 'returns first and last name' do
      person = build(:person, first_name: 'Luke', last_name: 'Skywalker')
      expect(person.full_name).to eq('Luke Skywalker')
    end

    it 'returns only first name when last name is nil' do
      person = build(:person, first_name: 'Chewbacca', last_name: nil)
      expect(person.full_name).to eq('Chewbacca')
    end
  end

  describe '.search' do
    before do
      Person.destroy_all
      create(:person, first_name: 'Luke', last_name: 'Skywalker')
      create(:person, first_name: 'Leia', last_name: 'Organa')
      create(:person, first_name: 'Han', last_name: 'Solo')
    end

    it 'filters by first_name' do
      results = Person.search('Luke')
      expect(results.count).to eq(1)
      expect(results.first.first_name).to eq('Luke')
    end

    it 'filters by last_name' do
      results = Person.search('Solo')
      expect(results.count).to eq(1)
      expect(results.first.last_name).to eq('Solo')
    end

    it 'is case-insensitive' do
      results = Person.search('luke')
      expect(results.count).to eq(1)
    end

    it 'returns all records when query is blank' do
      expect(Person.search('').count).to eq(3)
      expect(Person.search(nil).count).to eq(3)
    end
  end
end
