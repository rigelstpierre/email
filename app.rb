require 'sinatra'
require 'sinatra/activerecord'

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
end

class User < ActiveRecord::Base
 validates :email, presence: true
 validates_uniqueness_of :email
 validates_uniqueness_of :uuid
end

get '/' do
  @users = User.all
  erb :index
end

post '/register' do
  @user = User.create(email: params[:email], uuid: SecureRandom.hex(10))
  @user.to_json
end

