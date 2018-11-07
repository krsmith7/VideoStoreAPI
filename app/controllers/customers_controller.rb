class CustomersController < ApplicationController

  def index
    if params[:sort].present?
      sort_field = params[:sort]
      # REFACTOR: use compact if [array] statement
      case sort_field
        when "name"
          customers = Customer.all.sort_by do |customer|
            customer[:name]
          end
        when "id"
          customers = Customer.all.sort_by do |customer|
            customer[:id]
          end
        when "postal_code"
          customers = Customer.all.sort_by do |customer|
            customer[:postal_code]
          end
        when "registered_at"
          customers = Customer.all.sort_by do |customer|
            customer[:registered_at]
          end
      end

    else
      customers = Customer.all
    end

    render json: customers.as_json(only: [:id, :name, :registered_at, :postal_code, :phone, :movies_checked_out_count])
  end

end
