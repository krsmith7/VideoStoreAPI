require "test_helper"

describe Movie do
  describe 'validations' do
    it "must be valid with all params present" do
      movie = movies(:movie_with_all_params)
      result = movie.valid?

      expect(result).must_equal true
    end

    it "must be valid with only title and inventory present" do
      movie = movies(:movie_with_title_and_inv)
      result = movie.valid?

      expect(result).must_equal true
    end

    it "must have a unique title" do
      movie = Movie.new(title: "Parkor", inventory: 7)
      movie.title = movies(:existing_movie).title

      result = movie.valid?
      expect(result).must_equal false
    end

    it "must be invalid without a title" do
      movie = movies(:existing_movie)
      movie.title = nil

      result = movie.valid?
      expect(result).must_equal false
    end

    it "must be invalid without inventory" do
      movie = movies(:existing_movie)
      movie.inventory = nil

      result = movie.valid?
      expect(result).must_equal false
    end

    it "must be invalid if inventory is not an integer" do
      movie = movies(:movie_with_all_params)
      movie.inventory = "three"

      result = movie.valid?
      expect(result).must_equal false
    end


    it "must be invalid if inventory is less than 1" do
      movie = movies(:movie_with_all_params)
      movie.inventory = 0

      result = movie.valid?
      expect(result).must_equal false
    end
  end
end
