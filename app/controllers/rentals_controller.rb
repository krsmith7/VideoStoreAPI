class RentalsController < ApplicationController

  def checkout
    movie = Movie.find_by(id: rental_params[:movie_id])
    customer = Customer.find_by(id: rental_params[:customer_id])

    if customer && movie && movie.available_inventory > 0
      rental = Rental.new(rental_params)

      if rental.save
        Movie.find(rental.movie_id).decrement!(:available_inventory)

        render json: {
          id: rental.id,
          customer: customer.name,
          customer_id: rental.customer_id,
          movie: movie.title,
          movie_id: rental.movie_id,
          checkout: rental.checkout,
          due_date: rental.due_date,
          returned: rental.returned
          }, status: :ok
      else
        render_error(:bad_request, rental.errors.messages)
      end
    elsif movie && customer
      render json: { errors: { inventory: ["No copies of this movie available right now"] } }, status: :bad_request
    else
      if movie == nil && customer == nil
        render json: { errors: [
          { movie_id: ["Movie not found :("] },
          { customer_id: ["Customer not found :("] }
        ] }, status: :not_found
      elsif movie == nil
        render json: { errors: { movie_id: ["Movie not found :("] } }, status: :not_found
      elsif customer == nil
        render json: { errors: { customer_id: ["Customer not found :("] } }, status: :not_found
      end
    end
  end

  def checkin
    rental = Rental.find_by(
      customer_id: rental_params[:customer_id],
      movie_id: rental_params[:movie_id],
      returned: false
    )

    if rental
      rental.movie.increment!(:available_inventory)
      rental.update_attribute(:returned, true)

      name = Customer.find(rental.customer_id).name
      title = Movie.find(rental.movie_id).title
      render json: {
        id: rental.id,
        customer: name,
        customer_id: rental.customer_id,
        movie: title,
        movie_id: rental.movie_id,
        checkout: rental.checkout,
        due_date: rental.due_date,
        returned: rental.returned
        }, status: :ok
    else
      render json: { errors: { rental: ["Rental not found"] } }, status: :not_found
    end
  end

  private

  def rental_params
    params.permit(:customer_id, :movie_id)
  end
end
