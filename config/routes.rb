# == Route Map
#
#   Prefix Verb URI Pattern         Controller#Action
# callback POST /callback(.:format) report#callback
# decision POST /decision(.:format) report#decision
#     auth GET  /auth(.:format)     report#auth
# 

Rails.application.routes.draw do
  post '/callback', to: 'report#callback'
  post '/decision', to: 'report#decision'
  get '/auth', to: 'report#auth'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
