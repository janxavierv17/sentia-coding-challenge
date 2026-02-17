class Person < ApplicationRecord
  include PgSearch::Model

  # Has two things connected, locations and affiliations.
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :affiliations

  validates :first_name, presence: true

  pg_search_scope :pg_search,
                  against: %i[first_name last_name],
                  using: {
                    tsearch: { prefix: true },
                    trigram: { threshold: 0.2 }
                  }

  def self.search(query)
    if query.blank?
      all
    else
      pg_search(query)
    end
  end

  def full_name
    [first_name, last_name].compact_blank.join(' ')
  end
end
