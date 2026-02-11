class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :weapon
      t.string :vehicle

      t.timestamps
    end
  end
end
