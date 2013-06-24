require 'sinatra'
require 'data_mapper'

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
	erb :main
end

get '/new' do
	erb :new_post
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
	@posts = Post.all :order => :id.desc
	erb :delete_post
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
