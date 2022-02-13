require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require './models'

enable :sessions

get '/' do
    erb :index
end

get '/signin' do
   erb :sign_in 
end

get '/signup' do
   erb :sign_up 
end

post '/signin' do
   user = User.find_by(mail: params[:mail])
   if user && user.authenticate(params[:password])
      session[:user] = user.id 
   end
end

post '/signup' do
   @user = User.create(mail:params[:mail], password:params[:password],
   password_confirmation:params[:password_confirmation]) 
   if @user.persisted? #登録済みだった場合の確認
      session[:user] = @user.id 
   end
   redirect '/'
end

get '/signout' do
   session[:user] = nil
   redirect '/'
end