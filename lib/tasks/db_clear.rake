namespace :db do
  desc "Clear all data from the database (People, Locations, Affiliations)"
  task clear_all: :environment do
    puts "⚠️  Clearing all data..."
    
    # Delete from join tables first to avoid Foreign Key violations
    ActiveRecord::Base.connection.execute("DELETE FROM locations_people")
    ActiveRecord::Base.connection.execute("DELETE FROM affiliations_people")
    
    # Now delete the main records
    deleted_people = Person.delete_all
    deleted_locations = Location.delete_all
    deleted_affiliations = Affiliation.delete_all
    
    # Reset primary key sequences (PostgreSQL specific)
    ActiveRecord::Base.connection.reset_pk_sequence!("people")
    ActiveRecord::Base.connection.reset_pk_sequence!("locations")
    ActiveRecord::Base.connection.reset_pk_sequence!("affiliations")
    
    puts "✅ Cleared join tables"
    puts "✅ Deleted #{deleted_people} people"
    puts "✅ Deleted #{deleted_locations} locations"
    puts "✅ Deleted #{deleted_affiliations} affiliations"
    puts "✨ Database is clean!"
  end
end
