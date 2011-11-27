Voteunit::Application.routes.draw do

  resources :ballots
  resources :users
  
  match "/users/new" => "users#new", :via => :post
  match "/users/lookup" => "users#lookup", :via => :post
  match "/debug" => "home#debug"
  root :to => "home#show"
end
