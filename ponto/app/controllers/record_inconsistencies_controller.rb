class RecordInconsistenciesController < ApplicationController
  authorize_roles :admin, :hr, :leader
  before_action :set_employee

  def update
    inconsistency = @employee.record_inconsistencies.find(params[:id])

    if inconsistency.update(inconsistency_params)
      redirect_to :back, notice: 'Inconsistência atualizada com sucesso.'
    else
      redirect_to :back, alert: 'Não foi possível atualizar a inconsistência: ' <<
        inconsistency.errors.full_messages.to_sentence
    end
  end

  private
    def employees_scope
      current_user.leader? ? current_user.led_employees : Employee
    end

    def inconsistency_params
      params.require(:record_inconsistency).permit(:notes).merge!(
        status: params[:verify] ? :verified : :granted
      )
    end

    def set_employee
      @employee = employees_scope.find(params[:employee_id])
    end
end
