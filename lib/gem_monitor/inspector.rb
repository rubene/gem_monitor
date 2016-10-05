module GemMonitor
  class Inspector
    require "erb"

    attr_accessor :results

    def initialize args = {}
    end

    def results
      @results ||= GemMonitor::Extractor.new.extract_project_gems
    end

    def scan
      results
      create_report_folder
      create_report_file
      puts "GemMonitor report completed!"
    end

  private

    def create_report_folder
      FileUtils.mkdir "gem_monitor" unless Dir.exists? output_folder_name
    end

    def create_report_file
      File.open(report_file_path, "w") do |f|
        f.write(build_template)
      end
    end

    def build_template
      ERB.new(File.read(erb_template).to_s).result(binding)
    end

    def erb_template
      "#{GemMonitor.root}/lib/gem_monitor/templates/index.html.erb"
    end

    def report_file_path
      "#{output_folder_name}/#{File.basename(erb_template, ".erb")}"
    end

    def output_folder_name
      "gem_monitor"
    end
  end
end
