Rails.application.routes.draw do
  resources_path_names new: 'novo', edit: 'editar'

  resources :departments, path: 'departamentos'
  resources :employees, path: 'funcionarios' do
    resources :record_inconsistencies, only: :update, path: 'inconsistencias'
  end
  resources :holidays, path: 'feriados', except: :show
  resource :holiday_import, only: [:new, :create], path: 'importar_feriados'
  resource :record_import, only: [:new, :create], path: 'importar_registros'
  resources :overtime_bank_payments, only: [:index, :new, :create, :destroy], path: 'pagamentos_saldo_horas'

  devise_for :users, path: 'usuarios', path_names: { sign_in: 'acessar', sign_out: 'sair' }
  root to: 'dashboard#index'
end
