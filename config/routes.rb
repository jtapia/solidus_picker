# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  get '/picker', to: 'picker#export'
  post '/picker', to: 'picker#shipnotify'
end
