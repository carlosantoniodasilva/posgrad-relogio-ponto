class OvertimeBankPaymentsController < ApplicationController
  authorize_roles :admin, :hr

  def index
    @overtime_bank_payments = OvertimeBankPayment.order(id: :desc)
  end

  def new
    @overtime_bank_payment = OvertimeBankPayment.new
  end

  def create
    @overtime_bank_payment = OvertimeBankPayment.new(overtime_bank_payment_params)

    if @overtime_bank_payment.save
      redirect_to overtime_bank_payments_path, notice: 'Pagamento de Horas criado com sucesso.'
    else
      render :new
    end
  end

  def destroy
    @overtime_bank_payment = OvertimeBankPayment.find(params[:id])
    @overtime_bank_payment.destroy
    redirect_to overtime_bank_payments_path, notice: 'Pagamento de Horas removido com sucesso.'
  end

  private
    def overtime_bank_payment_params
      params.require(:overtime_bank_payment).permit(:employee_id, :paid_time)
    end
end
