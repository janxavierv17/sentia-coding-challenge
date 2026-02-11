class CreateLocationsPeople < ActiveRecord::Migration[8.1]
  def change
    create_table :locations_people, id: false do |t|
      t.references :person, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
    end
    add_index :locations_people, [:person_id, :location_id], unique: true
  end
end
