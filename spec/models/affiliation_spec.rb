# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Affiliation, type: :model do
  describe 'validations' do
    subject { build(:affiliation) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:people) }
  end
end
