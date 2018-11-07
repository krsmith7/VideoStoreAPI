class RentalsController < ApplicationController

  def checkout
    movie = Movie.find(checkout_params[:movie_id])
    if movie.availabe_inventory > 0
      rental = Rental.new(checkout_params)

      if rental.save
        Movie.find(rental.movie_id).decrement!(:available_inventory)

        name = Customer.find(rental.customer_id).name
        title = Movie.find(rental.movie_id).title
        render json: {
          customer: name,
          customer_id: rental.customer_id,
          movie: title,
          movie_id: rental.movie_id,
          checkout: rental.checkout,
          due_date: rental.due_date,
          returned: rental.returned
          }, status: :ok
      else
        render_error(:bad_request, rental.errors.messages)
      end
    else
      render json: { errors: { inventory: ["No copies of this movie available right now"] } }, status: :bad_request
    end
  end

  def checkin
    rental = Rental.find_by(
      customer_id: checkin_params[:customer_id],
      movie_id: checkin_params[:movie_id],
      returned: false
    )

    if rental
      rental.movie.increment!(:available_inventory)
      rental.update_attribute(:returned, true)

      name = Customer.find(rental.customer_id).name
      title = Movie.find(rental.movie_id).title
      render json: {
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

  def checkout_params
    params[:checkout] = Date.today
    params[:due_date] = Date.today + 7
    params.permit(:customer_id, :movie_id, :checkout, :due_date)
  end

  def checkin_params
    params.permit(:customer_id, :movie_id)
  end
end
