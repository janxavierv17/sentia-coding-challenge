#region import_people_path
class PeopleController < ApplicationController
  def index
    @people = fetch_people

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # Maps to routes.rb post :import
  def import
    if params[:file].blank?
      flash[:alert] = 'Please select a CSV file to import.'
      respond_to do |format|
        format.html { redirect_to people_path, status: :see_other }
        format.turbo_stream { 
          flash.now[:alert] = 'Please select a CSV file to import.'
          render turbo_stream: turbo_stream.replace('flash', partial: 'shared/flash') 
        }
      end
      return
    end

    begin
      result = CsvImporter.new(params[:file].tempfile).call

      if result.errors.any?
        @message = "Import completed with errors: #{result.errors.join(', ')}"
        @flash_type = :alert
      else
        @message = "Successfully imported #{result.imported_count} people. #{result.skipped_count} rows skipped."
        @flash_type = :notice
      end
    rescue StandardError => e
      @message = "Import failed: #{e.message}"
      @flash_type = :alert
    end

    respond_to do |format|
      format.html { redirect_to people_path, @flash_type => @message, status: :see_other }
      format.turbo_stream do
        flash.now[@flash_type] = @message
        @people = fetch_people(page: 1, search: nil)

        # Find the element with id and replace it with the partial html.
        render turbo_stream: [
          turbo_stream.replace('flash', partial: 'shared/flash'),
          turbo_stream.replace('import-form-container', partial: 'people/import_form'),
          turbo_stream.replace('search-container', partial: 'people/search_form'),
          turbo_stream.replace('people_table', partial: 'people/table', locals: { people: @people })
        ]
      end
    end
  end

  private

  # A list of columns that user is allowed to sort by.
  # Avoids complex quries for many to many relationsips and sql injection
  SORTABLE_COLUMNS = %w[first_name last_name weapon vehicle].freeze

  def sort_column
    SORTABLE_COLUMNS.include?(params[:sort]) ? params[:sort] : 'first_name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def fetch_people(page: params[:page], search: params[:search])
    # NAIVE APPROACH (Unoptimized):
    # This would cause an N+1 query problem because it fetches locations/affiliations 
    # for each person individually during view rendering (one query per association per row).
    # @people = Person.search(params[:search])
    #                 .order(sort_column => sort_direction)
    #                 .page(params[:page])
    #                 .per(10)

    # OPTIMIZED APPROACH (Eager Loading):
    # Uses .includes to fetch all associated records in just 3 queries total,
    # regardless of the number of people on the page.
    Person.includes(:locations, :affiliations)
          .search(search)
          .order(sort_column => sort_direction)
          .page(page)
          .per(10)
  end

  helper_method :sort_column, :sort_direction
end
#endregion