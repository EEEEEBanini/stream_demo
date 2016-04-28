Rails.application.routes.draw do
  get 'browse/', to: 'browse#index', format: false
  get 'browse/*path', to: 'browse#index', format: false
end
