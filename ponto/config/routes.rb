Rails.application.routes.draw do
  resources_path_names new: 'novo', edit: 'editar'
  resources :departments, path: 'departamentos'

  devise_for :users, path: 'usuarios', path_names: { sign_in: 'acessar', sign_out: 'sair' }
  root to: 'dashboard#index'
end
