require "test_helper"

describe Rental do

  describe 'validations' do

    before do
      @rental = rentals(:rental_one)
    end

    it 'is valid when all fields present' do
      expect(@rental.valid?).must_equal true
    end

    it 'is invalid without a checkout' do
      @rental.checkout = nil
      expect(@rental.valid?).must_equal false
      expect(@rental.errors.messages).must_include :checkout
    end

    it 'is invalid without a due_date' do
      @rental.due_date = nil
      expect(@rental.valid?).must_equal false
      expect(@rental.errors.messages).must_include :due_date
    end

    it 'is invalid when checkout is not a Date object' do
      @rental.checkout = "hahahaa"
      expect(@rental.valid?).must_equal false
      expect(@rental.errors.messages).must_include :checkout
    end

    it 'is invalid when due_date is not a Date object' do
      @rental.due_date = "hahahaa"
      expect(@rental.valid?).must_equal false
      expect(@rental.errors.messages).must_include :due_date
    end

  end

  describe 'relations' do

    before do
      @movie = movies(:existing_movie)
      @customer = customers(:jarth)
      @rental = Rental.new(checkout: Date.new(2018,10,1), due_date: Date.new(2018,10,8))
    end

    it 'can set movie through "movie"' do
      @rental.movie = @movie
      expect(@rental.movie_id).must_equal @movie.id
    end

    it 'can set movie through "movie_id"' do
      @rental.movie_id = @movie.id
      expect(@rental.movie).must_equal @movie
    end

    it 'can set customer through "customer"' do
      @rental.customer = @customer
      expect(@rental.customer_id).must_equal @customer.id
    end

    it 'can set customer through "customer_id"' do
      @rental.customer_id = @customer.id
      expect(@rental.customer).must_equal @customer
    end

  end

end
