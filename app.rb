require 'sinatra'
require 'sinatra/activerecord'
require 'dotenv'
require 'mandrill'

Dotenv.load

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
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
  else
    m = Mandrill::API.new
    message = {
    :subject=> "Hello from the Mandrill API",
    :from_name=> "Your name",
    :text=>"Hi message, how are you?",
    :to=>[
      {
        :email=> "rigel@rigel.co",
        :name=> "Recipient1"
      }
    ],
    :html=>"<html><h1>Hi <strong>message</strong>, how are you?</h1></html>",
    :from_email=>"rigel@rigel.co"
    }
    m.messages.send message
    'Message Sent'
  end
end

