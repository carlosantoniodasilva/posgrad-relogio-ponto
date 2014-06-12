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
