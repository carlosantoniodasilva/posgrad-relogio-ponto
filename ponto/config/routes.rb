Rails.application.routes.draw do
  resources_path_names new: 'novo', edit: 'editar'

  resources :departments, path: 'departamentos'
  resources :employees, path: 'funcionarios'
  resources :holidays, path: 'feriados', except: :show
  resource :holiday_import, only: [:new, :create], path: 'importar_feriados'
  resource :record_import, only: [:new, :create], path: 'importar_registros'

  devise_for :users, path: 'usuarios', path_names: { sign_in: 'acessar', sign_out: 'sair' }
  root to: 'dashboard#index'
end
