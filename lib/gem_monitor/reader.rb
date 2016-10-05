# Returns a string of a file
module GemMonitor
  class Reader

    def self.read file_name
      begin
        File.read file_name
      rescue => e
        raise GemMonitor::Error.new("Could not find file #{file_name}.")
      end
    end

  end
end
