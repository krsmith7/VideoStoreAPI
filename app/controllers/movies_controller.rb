class MoviesController < ApplicationController
  def index
    movies = Movie.all
    render json: movies.as_json(only: [:id, :title, :release_date])
  end

  def show
    movie = Movie.find_by(id: params[:id])
    # error handling
    render json: movie.as_json(only: [:title, :overview, :release_date, :inventory, :available_inventory])
  end

  def zomg
    render json: {something: "it works!"}
  end
end
