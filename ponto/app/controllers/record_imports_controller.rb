class RecordImportsController < ApplicationController
  authorize_roles :admin, :hr

  rescue_from RecordImporter::Connection::Error do
    redirect_to new_record_import_path, error: 'Não foi possível comunicar-se com o relógio ponto.'
  end

  rescue_from RecordImporter::EmployeeNotFound do |exception|
    redirect_to new_record_import_path, error: 'Não foi possível importar os registros: ' \
      "funcionário com o código #{exception.employee_id} não encontrado."
  end

  rescue_from RecordImporter::ParseError do |exception|
    redirect_to new_record_import_path, error: 'Não foi possível importar os registros: ' \
      "#{exception.message}. Por favor verifique a API e tente novamente."
  end

  def new
    @last_group = RecordGroup.last

    if @last_group
      @records = @last_group.records.preload(:employee).
        joins(:employee).order('employees.name', :date, :time)
    end
  end

  def create
    @importer = RecordImporter.new

    if @importer.import!
      redirect_to new_record_import_path, notice: 'Importação de registros do ponto efetuada com sucesso.'
    else
      flash.now[:alert] = 'Nenhum registro encontrado no relógio ponto.'
      render :new
    end
  end
end
