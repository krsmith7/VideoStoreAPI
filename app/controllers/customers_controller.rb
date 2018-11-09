class CustomersController < ApplicationController

SORTABLE_FIELDS = %w(name postal_code registered_at)
  def index
    if params[:sort] && SORTABLE_FIELDS.include?(params[:sort])
      sort_field = params[:sort]
      customers = Customer.all.order(sort_field)
    else
      customers = Customer.all
    end

    render json: customers.as_json(only: [:id, :name, :registered_at, :postal_code, :phone, :movies_checked_out_count])
  end

end
