require "test_helper"

describe Customer do

  before do
    @customer = customers(:jarth)
  end

  describe 'validations' do

    it 'is valid when all fields are pwesent' do
      result = @customer.valid?
      binding.pry

      expect(result).must_equal true
    end

    it 'is invalid without name arg' do
      @customer.name = nil

      result = @customer.valid?

      expect(result).must_equal false
      expect(@customer.errors.messages).must_include :name
    end

    it 'is invalid when name is empty str' do
      @customer.name = ""

      result = @customer.valid?

      expect(result).must_equal false
      expect(@customer.errors.messages).must_include :name
    end

  end

  describe 'relations' do

    it 'can access rentals through .rentals' do
      custy = customers(:jarth)
      jarth_rentals = Rental.where(customer: custy)

      expect(custy.rentals.length).must_equal jarth_rentals.length
      custy.rentals.each do |rental|
        expect(rental).must_be_instance_of Rental
      end
    end

  end

end
