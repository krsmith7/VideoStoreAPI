class MoviesController < ApplicationController
  def index
    movies = Movie.all
    render json: movies.as_json(only: [:id, :title, :release_date]), status: :success
  end

  def show
    movie = Movie.find_by(id: params[:id])
    # error handling
    render json: movie.as_json(only: [:title, :overview, :release_date, :inventory, :available_inventory]), status: :success
  end

  def create
    movie = Movie.new(movie_params)
    if movie.save
      render json: { id: movie.id }, status: :success
    else
      #error handling
    end
  end

  def zomg
    render json: {something: "it works!"}
  end

  private

  def movie_params
    params[:release_date] = parse_date(params[:release_date])
    params.permit(:title, :overview, :release_date, :inventory)
  end

  def parse_date(string)
    arr = string.split("-")
    return Date.new(arr[0].to_i, arr[1].to_i, arr[2].to_i)
  end

end
