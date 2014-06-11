class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  def index
    @departments = Department.order(:name)
  end

  def show
  end

  def new
    @department = Department.new
  end

  def edit
  end

  def create
    @department = Department.new(department_params)

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
    @department.destroy
    redirect_to departments_url, notice: 'Departamento removido com sucesso.'
  end

  private
    def set_department
      @department = Department.find(params[:id])
    end

    def department_params
      params.require(:department).permit(:name)
    end
end
