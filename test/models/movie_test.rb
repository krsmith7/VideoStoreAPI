require "test_helper"

describe Movie do
  # let(:movie) { Movie.new }

  it "must be valid" do
    movie = movies(:movie_with_all_params)
    movie.must_be :valid?
  end
end
