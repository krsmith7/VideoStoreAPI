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

    it "responds with not found error message if no movie is found" do
      invalid_id = 00
      get movie_path(invalid_id)
      must_respond_with :not_found

      body = JSON.parse(response.body)
      expect(body["errors"]).must_include "movie_id"
    end
  end

  describe "create" do
    let(:movie_input) {
      {
        title: "Gingerbread Ginger",
        overview: "A tale of two gingerbread people",
        release_date: "1998-12-25",
        inventory: 5
      }
    }

    it "creates new movie given valid data" do
      expect {post movies_path, params: movie_input
        }.must_change "Movie.count", 1

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body).must_include "id"

      created_movie = Movie.find(body["id"].to_i)
      expect(created_movie.title).must_equal movie_input[:title]
      must_respond_with :success
    end

    it "returns bad request error for missing title" do
      movie_input["title"] = nil

      expect {
        post movies_path, params: movie_input
      }.wont_change "Movie.count"

      body = JSON.parse(response.body)
      expect(body).must_include "errors"
      expect(body["errors"]).must_include "title"
      must_respond_with :bad_request
    end
  end

end
