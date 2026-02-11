class PeopleController < ApplicationController
  def index
    @people = Person.includes(:locations, :affiliations)
                    .search(params[:search])
                    .order(sort_column => sort_direction)
                    .page(params[:page])
                    .per(10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def import
    if params[:file].blank?
      redirect_to people_path, alert: 'Please select a CSV file to import.'
      return
    end

    begin
      result = CsvImporter.new(params[:file].tempfile).call

      if result.errors.any?
        redirect_to people_path, alert: "Import completed with errors: #{result.errors.join(', ')}"
      else
        redirect_to people_path,
                    notice: "Successfully imported #{result.imported_count} people. #{result.skipped_count} rows skipped."
      end
    rescue StandardError => e
      redirect_to people_path, alert: "Import failed: #{e.message}"
    end
  end

  private

  SORTABLE_COLUMNS = %w[first_name last_name weapon vehicle].freeze

  def sort_column
    SORTABLE_COLUMNS.include?(params[:sort]) ? params[:sort] : 'first_name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  helper_method :sort_column, :sort_direction
end
