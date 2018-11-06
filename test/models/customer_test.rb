require "test_helper"

describe Customer do

  describe 'validations' do

    before do
      @customer = customers(:jarth)
    end

    it 'is valid when all fields are pwesent' do
      result = @customer.valid?

      expect(result).must_equal true
    end

    it 'fails without name arg' do
      @customer.name = nil

      result = @customer.valid?

      expect(result).must_equal false
      expect(@customer.errors.messages).must_include :name
    end

    it 'fails when name is empty str' do
      @customer.name = ""

      result = @customer.valid?

      expect(result).must_equal false
      expect(@customer.errors.messages).must_include :name
    end

  end

end
