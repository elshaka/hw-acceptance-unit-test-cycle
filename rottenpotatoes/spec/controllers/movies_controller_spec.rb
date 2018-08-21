require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe "GET same_director" do
    before(:each) do
      @fake_movie = FactoryGirl.create(:movie)
      Movie.stub(:find_by_id).and_return(@fake_movie)
    end

    it 'looks for the current movie' do
      expect(Movie).to receive(:find_by_id).with("movie_id")

      get :same_director, {movie_id: "movie_id"}

      expect(assigns(:movie)).to eq(@fake_movie)
    end

    it 'gets other movies by the same director if the movie has director info' do
      fake_results = [double('Pretty much'), double('Anything'), double("Does this make sense?")]
      Movie.any_instance.stub(:same_director).and_return(fake_results)

      get :same_director, {movie_id: "movie_id"}

      expect(assigns(:movies)).to eq(fake_results)
    end

    it 'redirects to the home page if the movie has no director info' do
      Movie.stub(:find_by_id).and_return(FactoryGirl.create(:movie, :no_director))

      get :same_director, {movie_id: "movie_id"}

      expect(response).to redirect_to movies_path
    end
  end

  describe "GET index" do
    it 'returns all movies if no ratings params are passed' do
      FactoryGirl.create_list(:movie, 10)

      get :index

      expect(assigns(:movies).count).to eq 10
    end

    it 'only returns movies with selected ratings' do
      Movie.all_ratings.each { |rating| FactoryGirl.create(:movie, rating: rating) }

      selected_ratings = ["PG", "R"]
      selected_ratings_params = selected_ratings.each_with_object({}) { |rating, hash| hash[rating] = "1" }

      session.stub(:[])
      session.stub(:[]).with(:ratings).and_return selected_ratings_params

      get :index, {ratings: selected_ratings_params}

      expect(assigns(:movies).pluck(:rating).uniq).to match_array selected_ratings
    end

    it 'returns movies ordered by title if requested' do
      movie_titles = ["Zeigeist", "Jumanji", "Aladdin"]
      movie_titles.each { |title| FactoryGirl.create(:movie, title: title)}

      session.stub(:[])
      session.stub(:[]).with(:sort).and_return 'title'

      get :index, {sort: 'title'}

      movie_results_titles = assigns(:movies).pluck(:title)

      expect(movie_results_titles).to eq movie_titles.sort
    end

    it 'returns movies ordered by release date if requested' do
      movie_dates = ["2011-12-12", "1998-10-12", "1950-1-2"]
      movie_dates.each { |date| FactoryGirl.create(:movie, release_date: date)}

      session.stub(:[])
      session.stub(:[]).with(:sort).and_return 'release_date'

      get :index, {sort: 'release_date'}

      movie_results_dates = assigns(:movies).pluck(:release_date)

      expect(movie_results_dates).to eq movie_dates.sort
    end

    it 'redirects with remembered sort and order params if they are not provided' do
      @session_ratings = {"PG" => "1", "R" => "1"}
      @session_order = 'release_date'
      session.stub(:[])
      session.stub(:[]).with(:ratings).and_return @session_ratings
      session.stub(:[]).with(:sort).and_return @session_order

      get :index

      expect(response).to redirect_to(movies_path(ratings: @session_ratings, sort: @session_order))
    end

    it 'redirects with updated sort params if new ones are given' do
      @session_ratings = {"PG" => "1", "R" => "1"}
      session.stub(:[])
      session.stub(:[]).with(:ratings).and_return @session_ratings
      session.stub(:[]).with(:sort).and_return 'release_date'

      get :index, {sort: 'title'}

      expect(response).to redirect_to(movies_path(ratings: @session_ratings, sort: 'title'))
    end
  end

  describe "POST create" do
    before(:each) do
      @movie_params = {title: "Something", rating: "PG", director: "Awful", release_date: "1985-09-11"}
      post :create, {movie: @movie_params}
    end

    it 'creates a movie with the given params' do
      created_movie = Movie.last
      @movie_params.each do |param, value|
        expect(created_movie[param]).to eq value
      end
    end

    it 'redirects to the movies path' do
      expect(response).to redirect_to movies_path
    end
  end

  describe "GET show" do
    before(:each) do
      @movie = FactoryGirl.create(:movie)
    end

    it 'gets the right movie' do
      get :show, {id: @movie.id}

      expect(assigns(:movie)).to eq @movie
    end
  end

  describe "GET edit" do
    before(:each) do
      @movie = FactoryGirl.create(:movie)
    end

    it 'gets the right movie' do
      get :edit, {id: @movie.id}

      expect(assigns(:movie)).to eq @movie
    end
  end

  describe "PUT update" do
    before(:each) do
      @movie = Movie.create
      @movie_params = {title: "Something", rating: "PG", director: "Awful", release_date: "1985-09-11"}
    end

    it 'updates the details of a movie' do
      put :update, {id: @movie.id, movie: @movie_params}

      updated_movie = Movie.find(@movie.id)

      @movie_params.each do |param, value|
        expect(updated_movie[param]).to eq value
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @movie = FactoryGirl.create(:movie)
    end

    it 'deletes the right movie' do
      delete :destroy, {id: @movie.id}

      expect(Movie.find_by_id(@movie.id)).to be nil
    end
  end
end
