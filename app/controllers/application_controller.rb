class ApplicationController < ActionController::Base
  protect_from_forgery

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def protect_route
    redirect_to :back unless logged_in?
  end
end
