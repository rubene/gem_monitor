module GemMonitor
  class Reader

    attr_accessor :file_path

    def initialize args = {}
      self.file_path = args.fetch(:file_path, nil)
    end

    def read
      begin
        File.read file_path
      rescue => e
        raise GemMonitor::Error.new("Could not find file #{file_path}.")
      end
    end
  end
end
