module GemMonitor
  class Inspector
    require "erb"

    attr_accessor :project_gems

    def project_gems
      @project_gems ||= GemMonitor::Extractor.new.extract_project_gem_objects
    end

    def scan
      project_gems
      create_report_folder
      create_report_file
      puts "GemMonitor report completed!"
    end

  private

    def create_report_folder
      FileUtils.mkdir GemMonitor.output_folder_name unless Dir.exists? GemMonitor.output_folder_name
    end

    def create_report_file
      File.open(GemMonitor.report_file_path, "w") do |f|
        f.write(build_template)
      end
    end

    def build_template
      ERB.new(File.read(GemMonitor.report_erb_template).to_s).result(binding)
    end
  end
end
