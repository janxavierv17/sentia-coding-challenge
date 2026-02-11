class CreateAffiliationsPeople < ActiveRecord::Migration[8.1]
  def change
    create_table :affiliations_people, id: false do |t|
      t.references :person, null: false, foreign_key: true
      t.references :affiliation, null: false, foreign_key: true
    end
    add_index :affiliations_people, [:person_id, :affiliation_id], unique: true
  end
end
