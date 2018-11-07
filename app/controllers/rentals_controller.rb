class RentalsController < ApplicationController

  def checkout
    movie = Movie.find(rental_params[:movie_id])
    if movie.inventory > 0
      rental = Rental.new(rental_params)

      if rental.save
        Movie.find(rental.movie_id).decrement!(:inventory)

        name = Customer.find(rental.customer_id).name
        title = Movie.find(rental.movie_id).title
        render json: {
          customer: name,
          customer_id: rental.customer_id,
          movie: title,
          movie_id: rental.movie_id,
          checkout: rental.checkout,
          due_date: rental.due_date
          }, status: :ok
      else
        render_error(:bad_request, movie.errors.messages)
      end
    else
      render json: { errors: { inventory: ["No copies of this movie available right now"] } }, status: :bad_request
    end
  end

  

  private

  def rental_params
    params[:checkout] = Date.today
    params[:due_date] = Date.today + 7
    params.permit(:customer_id, :movie_id, :checkout, :due_date)
  end
end
