require 'sinatra'
require 'sinatra/reloader'
require 'dotenv/load'
require 'json'
require 'rest-client'
require 'pry'

set :bind, '0.0.0.0'

REST_URL = "https://developer.api.yodlee.com/ysl/restserver/v1/"
COBRAND_LOGIN_URL = "cobrand/login"

COBRAND_LOGIN = ENV['COBRAND_LOGIN']
COBRAND_PASS = ENV['COBRAND_PASS']
LOGIN_NAME = ENV['LOGIN_NAME']
LOGIN_PASS = ENV['LOGIN_PASS']

def cobrand_login(payload)
  url = REST_URL + COBRAND_LOGIN_URL
  RestClient.post(url,
    payload.to_json,
    {content_type: :json,accept: :json}
  )
end

get '/yodlee-fastlink' do
  cobrand_login_payload = {
    "cobrand": {
      "cobrandLogin": COBRAND_LOGIN,
      "cobrandPassword": COBRAND_PASS,
      "locale": "en_US"
    }
  }
  cobrand_login_result = cobrand_login(cobrand_login_payload)
  #cobrand_login_result.body

  erb :index
end