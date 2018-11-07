class ApplicationController < ActionController::API

  def render_error(status, errors)
    render json: { errors: errors }, status: status
  end

  def params_check(params_meth)
  end

end
