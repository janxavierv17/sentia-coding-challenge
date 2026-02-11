class CreateAffiliations < ActiveRecord::Migration[8.1]
  def change
    create_table :affiliations do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :affiliations, :name, unique: true
  end
end
