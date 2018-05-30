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
TOKEN_URL = REST_URL + "user/accessTokens"

# Credentials
COBRAND_LOGIN = ENV['COBRAND_LOGIN']
COBRAND_PASS = ENV['COBRAND_PASS']
USER_ID = ENV['USER_ID']
USER_PASS = ENV['USER_PASS']
FINAPP_ID = "10003600"

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

def user_request(url,payload,cob_session)
  RestClient.post(url,
    payload.to_json,
    {content_type: :json, :authorization => "cobSession=#{cob_session}"}
  )
end

def token_request(url,cob_session,user_session)
  url = url + "?appIds=" + FINAPP_ID
  RestClient.get(url,
    {content_type: :json, :authorization => "cobSession=#{cob_session},userSession=#{user_session}"}
  )
end

get '/yodlee-fastlink' do

  COB_SESSION = JSON.parse( cobrand_request(COBRAND_LOGIN_URL, COBRAND_LOGIN_PARAMS).body )["session"]["cobSession"]
  USER_SESSION = JSON.parse( user_request(USER_LOGIN_URL, USER_LOGIN_PARAMS, COB_SESSION).body )["user"]["session"]["userSession"]
  ACCESS_TOKENS_BODY = JSON.parse( token_request(TOKEN_URL, COB_SESSION, USER_SESSION).body )
  ACCESS_TOKEN = ACCESS_TOKENS_BODY["user"]["accessTokens"][0]["value"]
  ENTRY_POINT_URL = ACCESS_TOKENS_BODY["user"]["accessTokens"][0]["url"]

  erb :index

end





