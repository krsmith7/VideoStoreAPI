require "test_helper"

describe MoviesController do
  describe "index" do
    it "is a functioning route" do
      get movies_path
      must_respond_with :success
    end

    it "returns json in response" do
      get movies_path
      expect(response.header['Content-Type']).must_include 'json'
    end

    it "returns an array" do
      get movies_path

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
    end

    it "returns all movies" do
      get movies_path

      body = JSON.parse(response.body)
      body.length.must_equal Movie.count
    end

    it "returns movies with all required fields" do
      movie_fields = %w(id release_date title)
      get movies_path

      body = JSON.parse(response.body)

      body.each do |movie|
        expect(movie.keys.sort).must_equal movie_fields
      end
    end
  end

  describe "show" do
    it "can get one movie" do
      get movie_path(movies(:movie).id)

      body = JSON.parse(response.body)
      must_respond_with :success
      expect(body).must_be_kind_of Hash
    end

    it "responds with not found message if no movie is found" do
      invalid_id = 00
      get movie_path(invalid_id)
      must_respond_with :not_found
    end
  end

end
