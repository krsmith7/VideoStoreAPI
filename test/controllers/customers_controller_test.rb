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

    it "returns customers with all required fields" do
      customer_detail_fields = %w(id movies_checked_out_count name phone postal_code registered_at)
      get customers_path

      body = JSON.parse(response.body)

      body.each do |customer|
        expect(customer.keys.sort).must_equal customer_detail_fields
      end
    end

    it "returns customers sorted if sort param present" do
      sorted_customers = Customer.all.order(name: :asc)

      get '/customers?sort=name'

      body = JSON.parse(response.body)
      expect(body.first["name"]).must_include sorted_customers.first[:name]
    end
  end
end
