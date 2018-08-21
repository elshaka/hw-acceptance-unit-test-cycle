require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe '#same_director' do
    before(:all) do
      FactoryGirl.create_list(:movie, 10)
      FactoryGirl.create_list(:movie, 2, :by_james_cameron)
      @movie = FactoryGirl.create(:movie, :by_james_cameron)
    end

    it 'does not include itself in the results' do
      movie_ids = @movie.same_director.pluck(:id)
      expect(movie_ids).not_to include @movie.id
    end

    it 'only returns movies by the same director' do
      movie_directors = @movie.same_director.pluck(:director).uniq
      expect(movie_directors).to contain_exactly(@movie.director)
    end

    after(:all) do
      Movie.destroy_all
    end
  end
end
