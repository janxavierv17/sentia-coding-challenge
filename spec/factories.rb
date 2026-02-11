# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    first_name { 'Luke' }
    last_name { 'Skywalker' }
    weapon { 'Lightsaber' }
    vehicle { 'X-wing Starfighter' }
  end

  factory :location do
    sequence(:name) { |n| "Location #{n}" }
  end

  factory :affiliation do
    sequence(:name) { |n| "Affiliation #{n}" }
  end
end
