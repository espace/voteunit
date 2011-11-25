Voteunit::Application.routes.draw do

  resources :ballots
  resources :users
  
  match "/users/new" => "users#new", :via => :post
  match "/users/lookup" => "users#lookup", :via => :post
  root :to => "home#show"
end
