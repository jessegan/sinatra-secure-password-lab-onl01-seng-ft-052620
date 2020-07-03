require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    if params[:username] != "" && params[:password] != ""
      user = User.new(username:params[:username],password:params[:password])
      if user.save
        redirect '/login'
      else
        redirect '/failure'
      end
    else
      redirect '/failure'
    end

  end

  get '/account' do
    if logged_in?
      @user = current_user
      erb :account
    else
      redirect '/login'
    end
  end

  get '/deposit' do
    if logged_in?
      @user = current_user
      erb :deposit 
    else 
      redirect '/login'
    end
  end

  patch '/deposit' do
    user=current_user
    user.balance += params['amount'].to_f
    user.save

    redirect '/account'
  end

  get '/withdrawal' do
    if logged_in?
      @user = current_user
      erb :withdrawal
    else 
      redirect '/login'
    end
  end

  patch '/withdrawal' do 
    user=current_user
    user.balance -= params['amount'].to_f
    user.save 

    redirect '/account'
  end

  get "/login" do
    if logged_in?
      redirect '/account'
    else 
      erb :login
    end
  end

  post "/login" do
    if params[:username] != "" && params[:password] != ""
      user = User.find_by(username:params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect '/account'
      else 
        redirect '/failure'
      end
    else
      redirect '/failure'
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
