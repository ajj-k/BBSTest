require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require './models'
require 'sinatra-websocket'

enable :sessions
set :sockets, []

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
      @articles = Article.all.order("created_at desc")
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
   current_user.articles.create(
      article: params[:article],
      reply_check: false,
      reply_id: -1,
      user_id: session[:user]
      )
   redirect "/bbs"
end

post '/reply' do
   current_user.articles.create(
      article: params[:reply_article],
      reply_check: false,
      reply_id: session[:reply],
      user_id: session[:user]
      )
   article = Article.find_by(id: session[:reply])
   article.reply_check = true
   article.save
   redirect "/bbs"
end

get '/reply/:id' do
   @article = Article.find_by(id: params[:id])
   session[:reply] = params[:id]
   erb :bbs_reply
end

get '/reply_view/:id' do
   @articles = Article.all.order("created_at desc").where(reply_id: params[:id])
   erb :reply_view
end

get '/bbs-js' do
   erb :js_bbs
end

get '/websocket' do
   if !require.websocket?
      erb :index
   else
      request.websocket do |ws|
         ws.onopen do
            ws.send("Hello World!")
            settings.sockets << ws
         end
         ws.onmessage do |msg|
            WM.next_tick do
               settings.sockets.each do |s|
                  s.send("Echo message: " + msg)
               end
            end
         end
         ws.onclose do
            warn("websocket closed")
            settings.sockets.delete(ws)
         end
      end
   end
end