class DashboardController < ApplicationController
  authorize_roles :admin, :hr, :leader

  def index
    @records = Record.pending_verification.includes(:employee, :inconsistency).
      order('employees.name', 'records.date')

    if current_user.leader?
      @records = @records.where(employee_id: current_user.led_employees)
    end
  end
end
