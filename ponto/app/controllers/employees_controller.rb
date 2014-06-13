class EmployeesController < ApplicationController
  authorize_roles :admin, :hr, except: [:index, :show]
  authorize_roles :admin, :hr, :leader, only: [:index, :show]
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  def index
    @employees = employees_scope.includes(:department, :user)
  end

  def show
    record_params = params.fetch(:record) {
      { from: Date.current.beginning_of_month, to: Date.current }
    }
    @from, @to = record_params[:from].presence, record_params[:to].presence

    if @from && @to
      @from = Date.parse(@from) if @from.is_a?(String)
      @to = Date.parse(@to) if @to.is_a?(String)

      @records = @employee.records.between(@from, @to).order(:date, :time)
    end
  end

  def new
    @employee = employees_scope.new
  end

  def edit
  end

  def create
    @employee = employees_scope.new(employee_params)

    if @employee.save
      redirect_to @employee, notice: 'Funcionário criado com sucesso.'
    else
      render :new
    end
  end

  def update
    attributes = employee_params
    user_attributes = attributes[:user_attributes]
    user_attributes.delete(:password) if user_attributes[:password].blank?
    user_attributes.delete(:password_confirmation) if user_attributes[:password_confirmation].blank?

    if @employee.update(attributes)
      redirect_to @employee, notice: 'Funcionário atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    if @employee.destroy
      redirect_to employees_path, notice: 'Funcionário removido com sucesso.'
    else
      redirect_to :back, alert: "Funcionário não pode ser removido: #{@employee.errors.full_messages.to_sentence}."
    end
  end

  private
    def set_employee
      @employee = employees_scope.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(
        :name, :department_id, user_attributes: [:id, :email, :password, :password_confirmation, :role, :_destroy]
      )
    end

    def employees_scope
      current_user.leader? ? current_user.led_employees : Employee
    end
end
