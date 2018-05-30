require 'sinatra'
require 'sinatra/reloader'
require 'dotenv/load'
require 'json'
require 'rest-client'
require 'pry'

set :bind, '0.0.0.0'

# URLs
REST_URL = "https://developer.api.yodlee.com/ysl/restserver/v1/"
COBRAND_LOGIN_URL = REST_URL + "cobrand/login"
USER_LOGIN_URL = REST_URL + "user/login"

# Credentials
COBRAND_LOGIN = ENV['COBRAND_LOGIN']
COBRAND_PASS = ENV['COBRAND_PASS']
USER_ID = ENV['USER_ID']
USER_PASS = ENV['USER_PASS']

# Params
COBRAND_LOGIN_PARAMS = {
  "cobrand": {
    "cobrandLogin": COBRAND_LOGIN,
    "cobrandPassword": COBRAND_PASS,
    "locale": "en_US"
  }
}

USER_LOGIN_PARAMS = {
  "user": {
    "loginName": USER_ID,
    "password": USER_PASS,
    "locale": "en_US"
  }
}

def cobrand_request(url,payload)
  RestClient.post(url,
    payload.to_json,
    {content_type: :json}
  )
end

def user_request(url,payload,auth)

  response = RestClient.post(url,
    payload.to_json,
    {content_type: :json, :authorization => "cobSession=#{auth}"}
  )
  # { |response,request,result|
  #     case response.code
  #     when 400
  #       [ :error, parse_json(response.to_str) ]
  #     else
  #       fail "Invalid response #{response.to_str} received."
  #     end
  # }

end

get '/yodlee-fastlink' do

  COB_SESSION = JSON.parse(cobrand_request(COBRAND_LOGIN_URL, COBRAND_LOGIN_PARAMS).body)["session"]["cobSession"]
  USER_SESSION = JSON.parse( user_request(USER_LOGIN_URL, USER_LOGIN_PARAMS, COB_SESSION).body)["user"]["session"]["userSession"]

  erb :index

end





