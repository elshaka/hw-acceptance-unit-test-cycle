FactoryGirl.define do
  factory :movie do
    title { Faker::Book.title }
    director { Faker::Book.author }
    rating { Movie.all_ratings.sample }

    trait :no_director do
      director ""
    end

    trait :by_james_cameron do
      director "James Cameron"
    end
  end
end
