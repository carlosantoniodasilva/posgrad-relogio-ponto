class HolidaysController < ApplicationController
  authorize_roles :admin, :hr
  before_action :set_holiday, only: [:edit, :update, :destroy]

  def index
    @holidays = Holiday.order(date: :desc)
  end

  def new
    @holiday = Holiday.new
  end

  def edit
  end

  def create
    @holiday = Holiday.new(holiday_params)

    if @holiday.save
      redirect_to holidays_path, notice: 'Feriado criado com sucesso.'
    else
      render :new
    end
  end

  def update
    if @holiday.update(holiday_params)
      redirect_to holidays_path, notice: 'Feriado atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    if @holiday.destroy
      redirect_to holidays_path, notice: 'Feriado removido com sucesso.'
    else
      redirect_to :back, alert: "Feriado não pode ser removido: #{@holiday.errors.full_messages.to_sentence}."
    end
  end

  private
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    def holiday_params
      params.require(:holiday).permit(:date, :name)
    end
end
