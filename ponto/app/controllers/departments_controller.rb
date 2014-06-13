class DepartmentsController < ApplicationController
  authorize_roles :admin, :hr, except: [:index, :show]
  authorize_roles :admin, :hr, :leader, only: [:index, :show]
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  def index
    @departments = departments_scope.includes(:leader).order(:name)
  end

  def show
    @employees = @department.employees.includes(:user).order(:name)
  end

  def new
    @department = departments_scope.new
  end

  def edit
  end

  def create
    @department = departments_scope.new(department_params)

    if @department.save
      redirect_to @department, notice: 'Departamento criado com sucesso.'
    else
      render :new
    end
  end

  def update
    if @department.update(department_params)
      redirect_to @department, notice: 'Departamento atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    if @department.destroy
      redirect_to departments_path, notice: 'Departamento removido com sucesso.'
    else
      redirect_to :back, alert: "Departamento não pode ser removido: #{@department.errors.full_messages.to_sentence}."
    end
  end

  private
    def set_department
      @department = departments_scope.find(params[:id])
    end

    def department_params
      params.require(:department).permit(:name, :leader_id)
    end

    def departments_scope
      current_user.leader? ? current_user.led_departments : Department
    end
end
