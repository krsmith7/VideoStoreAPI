require "test_helper"

describe RentalsController do

  describe "check-out" do
    let(:rental_input) {
      {
        customer_id: customers(:jarth).id,
        movie_id: movies(:existing_movie).id
      }
    }

    it "creates new rental given valid data and reduces movie avail_inv by 1" do
      starting_inv = movies(:existing_movie).available_inventory

      expect {
        post checkout_path, params: rental_input
      }.must_change "Rental.count", 1

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      # make sure the hash contains the right data:
      expect(body).must_include "returned"
      must_respond_with :success

      created_rental = Rental.find(body["id"].to_i)
      expect(created_rental.movie_id).must_equal rental_input[:movie_id]
      expect(created_rental.customer_id).must_equal rental_input[:customer_id]
      expect(created_rental.movie.available_inventory).must_equal starting_inv - 1
    end

    it "returns not found error for missing movie_id" do
      rental_input["movie_id"] = nil

      expect {
        post checkout_path, params: rental_input
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)
      expect(body).must_include "errors"
      expect(body["errors"]).must_include "movie_id"
      must_respond_with :not_found
    end

    it "returns not found error for missing customer_id" do
      rental_input["customer_id"] = nil

      expect {
        post checkout_path, params: rental_input
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)
      expect(body).must_include "errors"
      expect(body["errors"]).must_include "customer_id"
      must_respond_with :not_found
    end
  end

  describe "check-in" do
    let(:rental_input) {
      {
        customer_id: rentals(:rental_one).customer_id,
        movie_id: rentals(:rental_one).movie_id
      }
    }

    it 'checks in a rented movie when given valid data' do
      starting_inv = movies(:existing_movie).available_inventory

      post checkin_path, params: rental_input
      must_respond_with :success

      body = JSON.parse(response.body)
      created_rental = Rental.find(body["id"].to_i)

      returned = created_rental.returned
      expect(returned).must_equal true
      expect(created_rental.movie_id).must_equal rental_input[:movie_id]
      expect(created_rental.customer_id).must_equal rental_input[:customer_id]
      expect(created_rental.movie.available_inventory).must_equal starting_inv + 1
    end

    it 'returns errors for bad data' do
      rental_input["movie_id"] = nil
      rental_input["customer_id"] = nil

      post checkin_path, params: rental_input
      must_respond_with :not_found

      body = JSON.parse(response.body)
      expect(body).must_include "errors"
      expect(body["errors"]["rental"]).must_include "Rental not found"
    end

    it 'cannot check in a rental that has already been returned' do
      rental_input[:movie_id] = rentals(:done_rental).movie_id
      rental_input[:customer_id] = rentals(:done_rental).customer_id

      post checkin_path, params: rental_input
      must_respond_with :not_found

      body = JSON.parse(response.body)
      expect(body).must_include "errors"
      expect(body["errors"]["rental"]).must_include "Rental not found"
    end

  end

end
