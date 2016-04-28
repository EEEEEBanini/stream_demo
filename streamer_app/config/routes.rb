Rails.application.routes.draw do
  get 'download/', to: 'browse#download', format: false
  get 'browse/', to: 'browse#index', format: false
  get 'browse/*path', to: 'browse#index', format: false
end
