require "test_helper"

describe CustomersController do
  describe 'index' do
    it "is a functioning route" do
      get customers_path
      must_respond_with :success
    end

    it "returns response with json content" do
      get customers_path
      expect(response.header['Content-Type']).must_include 'json'
    end

    it "returns an Array from parsed JSON data" do
      get customers_path

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
    end

    it "returns correct number of Customers" do
      get customers_path

      body = JSON.parse(response.body)
      body.length.must_equal Customer.count
    end
  end
end
