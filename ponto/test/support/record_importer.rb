module Support
  module RecordImporter
    class ErrorConnection
      def get_records
        raise ::RecordImporter::Connection::Error.new
      end
    end

    class FakeConnection
      def initialize(records)
        @records = records
      end

      def get_records
        @records
      end
    end

    protected

    def stub_record_importer_connection(records)
      swap_connection FakeConnection.new(records) do
        yield
      end
    end

    def stub_record_importer_connection_error
      swap_connection ErrorConnection.new do
        yield
      end
    end

    def test_records
      [
        { 'Id' => 1, 'Funcionario' => { 'Id' => employees(:fabricio).id }, 'DataRegistro' => '10/06/2014', 'HoraRegistro' => '08:05:23' },
        { 'Id' => 2, 'Funcionario' => { 'Id' => employees(:fabricio).id }, 'DataRegistro' => '10/06/2014', 'HoraRegistro' => '12:00:04' },
        { 'Id' => 3, 'Funcionario' => { 'Id' => employees(:fabricio).id }, 'DataRegistro' => '10/06/2014', 'HoraRegistro' => '13:05:18' },
        { 'Id' => 4, 'Funcionario' => { 'Id' => employees(:fabricio).id }, 'DataRegistro' => '10/06/2014', 'HoraRegistro' => '16:58:02' },
        { 'Id' => 5, 'Funcionario' => { 'Id' => employees(:nilson).id },   'DataRegistro' => '11/06/2014', 'HoraRegistro' => '07:58:43' },
        { 'Id' => 6, 'Funcionario' => { 'Id' => employees(:nilson).id },   'DataRegistro' => '11/06/2014', 'HoraRegistro' => '12:02:53' },
        { 'Id' => 7, 'Funcionario' => { 'Id' => employees(:nilson).id },   'DataRegistro' => '11/06/2014', 'HoraRegistro' => '17:05:00' }
      ]
    end

    private

    def swap_connection(new_connection)
      original_connection = ::RecordImporter.connection
      ::RecordImporter.connection = new_connection
      yield
    ensure
      ::RecordImporter.connection = original_connection
    end
  end
end
