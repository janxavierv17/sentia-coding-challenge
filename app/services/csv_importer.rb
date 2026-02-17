# frozen_string_literal: true

require 'csv'

# Imports Star Wars character data from a CSV file into the database.
#
# Processing rules:
#   1. Rows with empty Affiliations are silently skipped.
#   2. first_name is required (rows without a name are skipped).
#   3. Names and Locations are converted to Title Case.
#   4. Locations and Affiliations are deduplicated via find_or_create_by.
#
# Usage:
#   CsvImporter.new(file).call
#
class CsvImporter
  Result = Struct.new(:imported_count, :skipped_count, :errors, keyword_init: true)

  def initialize(file)
    @file = file
    @imported = 0
    @skipped = 0
    @errors = []
  end

  def call
    # CSV.read() will load the whole file into RAM at once.
    # Using foreach (streaming) helps us keep the server's RAM usage low as possible.
    CSV.foreach(@file, headers: true, header_converters: :symbol) do |row|
      next unless valid_row?(row)

      process_row(row)
    rescue ActiveRecord::RecordInvalid => e
      @errors << "Row '#{row[:name]}': #{e.message}"
      @skipped += 1
    end

    Result.new(imported_count: @imported, skipped_count: @skipped, errors: @errors)
  end

  private

  def valid_row?(row)
    if row[:affiliations].blank? || row[:name].blank?
      @skipped += 1
      false
    else
      true
    end
  end

  def process_row(row)
    person = build_person(row)
    person.save!
    @imported += 1
  end

  private

  def build_person(row)
    first_name, last_name = split_name(row[:name])
    first_name = titleize(first_name)
    last_name = titleize(last_name) if last_name.present?

    person = Person.find_or_initialize_by(first_name: first_name, last_name: last_name)

    person.assign_attributes(
      weapon: row[:weapon].presence,
      vehicle: row[:vehicle].presence
    )

    person.locations = parse_locations(row[:location])
    person.affiliations = parse_affiliations(row[:affiliations])

    person
  end

  def split_name(full_name)
    parts = full_name.strip.split(' ')
    return [parts[0], nil] if parts.length == 1
    
    # Reverse split: assume last word is last name, everything else is first name
    last_name = parts.last
    first_name = parts[0..-2].join(' ')
    
    [first_name, last_name]
  end

  def parse_locations(raw)
    return [] if raw.blank?

    raw.split(',').map(&:strip).compact_blank.map do |name|
      Location.find_or_create_by!(name: titleize(name))
    end
  end

  def parse_affiliations(raw)
    return [] if raw.blank?

    raw.split(',').map(&:strip).compact_blank.map do |name|
      Affiliation.find_or_create_by!(name: name)
    end
  end

  def titleize(str)
    str.strip.split.map(&:capitalize).join(' ')
  end
end
