require 'sinatra'
require 'data_mapper'

def checkLogin (name, pass)
	if name == 'Jared' and pass == '*******' then
		return true
	else 
		return false
	end
end

enable :sessions

error do
	erb :'500'
end

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog_new.db")  

class Post
	include DataMapper::Resource
	property :id, Serial
	property :title, Text, :required => true
	property :content, Text, :required => true
	property :created_at, DateTime
end

DataMapper.finalize.auto_upgrade!

get '/' do
	if session[:user] == true then
		@admin = true
	else 
		@admin = false
	end
	erb :main
end

get '/new' do
	if session[:user] == true then
		erb :new_post
	else
		redirect '/auth'
	end
end

post '/new' do
	p = Post.new  
	p.title = params[:title]
	p.content = params[:content]
	p.created_at = Time.now  
	p.save  
	redirect '/posts'
end

get '/delete' do
	if session[:user] == true then
		@posts = Post.all :order => :id.desc
		erb :delete_post
	else
		redirect '/auth'
	end
end

post '/delete/:id' do
	p = Post.get params[:id]
	p.destroy 
	redirect '/posts'
end

get '/post/:id' do
	@post = Post.get params[:id]
	erb :post
end

get '/posts' do
	@posts = Post.all :order => :id.desc
	erb :posts
end

get '/auth' do
	erb :authorize
end

post '/auth' do
	if checkLogin(params[:name], params[:password]) then
		session[:user] = true
		redirect '/new'
	else 
		redirect '/auth'
	end
end

get '/logout' do
	session.clear
	redirect '/'
end