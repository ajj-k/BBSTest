require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require './models'

enable :sessions

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/' do
   erb :index
end

get '/signin' do
   erb :sign_in 
end

get '/signup' do
   erb :sign_up 
end

get '/signout' do
   session[:user] = nil
   redirect '/'
end

get '/bbs' do
   if current_user.nil?
      @articles = Article.none
   else
      @articles = Article.all
   end
   erb :bbs
end

post '/signin' do
   user = User.find_by(name: params[:mail])
   if user && user.authenticate(params[:password])
      session[:user] = user.id 
   end
   redirect '/'
end

post '/signup' do
   @user = User.create(name: params[:mail], password: params[:password],
   password_confirmation: params[:password_confirmation]) 
   if @user.persisted? #登録済みだった場合の確認
      session[:user] = @user.id 
   end
   redirect '/'
end

post '/post' do
   current_user.bbsdatas.create(
      article: params[:article],
      reply_check: false,
      reply_id: -1
      )
   redirect "/bbs"
end