class MoviesController < ApplicationController

SORTABLE_FIELDS = %w(title release_date)
  def index
    if params[:sort] && SORTABLE_FIELDS.include?(params[:sort])
      sort_field = params[:sort]
      movies = Movie.all.order(sort_field)
    else
      movies = Movie.all
    end

    render json: movies.as_json(only: [:id, :title, :release_date]), status: :ok
  end

  def show
    movie = Movie.find_by(id: params[:id])

    if movie
      render json: movie.as_json(only: [:title, :overview, :release_date, :inventory, :available_inventory]), status: :ok
    else
      render_error(:not_found, { movie_id: ["Movie not found :("]})
    end
  end

  def create
    movie = Movie.new(movie_params)
    if movie.save
      render json: { id: movie.id }, status: :ok
    else
      render_error(:bad_request, movie.errors.messages)
    end
  end

  def zomg
    render json: {something: "it works!"}
  end

  private

  def movie_params
    params.permit(:title, :overview, :release_date, :inventory, :available_inventory)
  end

end
