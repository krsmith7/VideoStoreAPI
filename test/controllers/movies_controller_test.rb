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
  end
end
