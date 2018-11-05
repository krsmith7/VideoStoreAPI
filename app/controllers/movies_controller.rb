class MoviesController < ApplicationController
  def zomg
    render json: {something: "it works!"}
  end
end
