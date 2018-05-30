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

COBRAND_LOGIN_PARAMS = {
  "cobrand": {
    "cobrandLogin": COBRAND_LOGIN,
    "cobrandPassword": COBRAND_PASS,
    "locale": "en_US"
  }
}

COBRAND_LOGIN_URL = REST_URL + COBRAND_LOGIN_URL

def post_request(url,payload)
  RestClient.post(url,
    payload.to_json,
    {content_type: :json,accept: :json}
  )
end

get '/yodlee-fastlink' do

  cob_session = JSON.parse(post_request(COBRAND_LOGIN_URL, COBRAND_LOGIN_PARAMS).body)["session"]["cobSession"]
  # cobrand_login_result.body
  binding.pry

  erb :index

end





