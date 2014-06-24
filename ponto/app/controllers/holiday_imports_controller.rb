class HolidayImportsController < ApplicationController
  authorize_roles :admin, :hr

  rescue_from HolidayImporter::ParseError do
    flash.now[:error] = 'Não foi possível ler todos os feriados do arquivo, ' \
      'por favor verifique e tente novamente.'
    render :new
  end

  def new
    @importer = HolidayImporter.new
  end

  def create
    @importer = HolidayImporter.new(holiday_importer_params)

    if @importer.import!
      redirect_to holidays_path, notice: 'Importação de feriados efetuada com sucesso: ' \
        "#{@importer.total_created} criado(s), #{@importer.total_updated} atualizado(s)."
    else
      flash.now[:alert] = "Error ao importar arquivo: #{@importer.errors.full_messages.to_sentence}."
      render :new
    end
  end

  private

  def holiday_importer_params
    (params[:holiday_importer] || {}).slice(:file)
  end
end
