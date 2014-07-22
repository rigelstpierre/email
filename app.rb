require 'sinatra'
require 'sinatra/activerecord'

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
end

class User < ActiveRecord::Base
end

get '/' do
  @users = User.all
  erb :index
end

post '/register' do
  if User.find_by(email: params[:email]).present?
    'User Already Exists'
  else
    @user = User.create(email: params[:email], uuid: SecureRandom.hex(10))
    @user.token.to_json
  end
end

post '/user/:uuid' do
  user = User.find_by(uuid: params[:uuid])
  if user.nil?
    'User Not Found'
  end
end

