Rails.application.routes.draw do
  root "game_board#startup"
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: "game_board#startup"
  post '/', to: "game_board#startup"
  get 'game/setup', to: "game_board#setup"
  post 'game/run', to: "game_board#run"
end
