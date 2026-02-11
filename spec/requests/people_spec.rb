# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'People', type: :request do
  describe 'GET /people' do
    it 'returns HTTP success' do
      get people_path, headers: { 'HOST' => 'localhost' }
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      get people_path, headers: { 'HOST' => 'localhost' }
      expect(response.body).to include('Galactic Census')
    end

    context 'when database is empty' do
      before { Person.destroy_all }

      it 'does not show search bar' do
        get people_path, headers: { 'HOST' => 'localhost' }
        expect(response.body).not_to include('Search by first or last name')
      end
    end

    context 'when database has people' do
      before do
        Person.destroy_all
        create(:person, first_name: 'Luke', last_name: 'Skywalker')
      end

      it 'shows search bar' do
        get people_path, headers: { 'HOST' => 'localhost' }
        expect(response.body).to include('Search by first or last name')
      end
    end

    context 'with people in the database' do
      before do
        Person.destroy_all
        15.times do |i|
          create(:person, first_name: "Person#{i}", last_name: "Last#{i}")
        end
      end

      it 'paginates results to 10 per page' do
        get people_path, headers: { 'HOST' => 'localhost' }
        expect(response.body.scan(/Person\d+/).uniq.size).to be <= 10
      end

      it 'supports page parameter' do
        get people_path(page: 2), headers: { 'HOST' => 'localhost' }
        expect(response).to have_http_status(:success)
      end
    end

    context 'with search' do
      before do
        Person.destroy_all
        create(:person, first_name: 'Luke', last_name: 'Skywalker')
        create(:person, first_name: 'Leia', last_name: 'Organa')
      end

      it 'filters by search parameter' do
        get people_path(search: 'Luke'), headers: { 'HOST' => 'localhost' }
        expect(response.body).to include('Luke')
        expect(response.body).not_to include('Leia')
      end
    end

    context 'with sorting' do
      before do
        Person.destroy_all
        create(:person, first_name: 'Zara', last_name: 'Last')
        create(:person, first_name: 'Adam', last_name: 'First')
      end

      it 'sorts ascending by default' do
        get people_path(sort: 'first_name', direction: 'asc'), headers: { 'HOST' => 'localhost' }
        expect(response).to have_http_status(:success)
        body = response.body
        expect(body.index('Adam')).to be < body.index('Zara')
      end

      it 'sorts descending' do
        get people_path(sort: 'first_name', direction: 'desc'), headers: { 'HOST' => 'localhost' }
        expect(response).to have_http_status(:success)
        body = response.body
        expect(body.index('Zara')).to be < body.index('Adam')
      end
    end
  end

end
