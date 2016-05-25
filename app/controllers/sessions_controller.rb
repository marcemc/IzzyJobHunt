class SessionsController < ApplicationController

  def new
  end

  def create
    p "<>"*47
    session[:userinfo]
    user = User.find_by(email: session[:email].downcase)
    if user && user.authenticate(params[:session][:password])
      @current_user ||= User.find_by(id: log_in(user))
      log_in user
      redirect_to user
    else
      flash.now[:danger]="Invalid email/password combination"
      render 'welcome/izzybam'
    end

    if !Rails.env.development?
      quote = HTTParty.get "//quotes.rest/qod.json?category=inspire"
      result = (JSON.parse quote.body)["contents"]["quotes"][0]
      session[:quote] = result["quote"]
      session[:image] = result["background"]
    end

  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end


end
