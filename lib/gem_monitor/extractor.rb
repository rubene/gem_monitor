module GemMonitor
  class Extractor
    attr_accessor :gem_objects, :gemfile_content, :gemfile_lock_content

    def initialize args = {}
      self.gem_objects = []
    end

    def gemfile_content
      @gemfile_content ||= read_gemfile
    end

    def gemfile_lock_content
      @gemfile_content ||= read_gemfile_lock
    end

    def extract_project_gem_objects
      extract_and_create_gems_objects
      gem_objects
    end

  private

    def read_gemfile
      GemMonitor::Reader.new(file_path: GemMonitor.configuration.gemfile_path).read
    end

    def read_gemfile_lock
      GemMonitor::Reader.new(file_path: GemMonitor.configuration.gemfile_lock_path).read
    end

    def project_gems_names
      (read_gemfile.scan(/^\s*gem "(.*?)"/) + read_gemfile.scan(/^\s*gem '(.*?)'/)).flatten
    end

    def extract_and_create_gems_objects
      gem_names_from_gemfile = project_gems_names
      raise_project_gems_error if gem_names_from_gemfile.empty?
      gem_names_from_gemfile.each do |project_gem_name|
        gem_object = GemObject.new(name: project_gem_name, project_version: extract_gem_version_for(project_gem_name))
        gem_object.latest_version
        self.gem_objects.push gem_object
      end
    end

    def raise_project_gems_error
      raise GemMonitor::Error.new("Could not extract gem names from your Gemfile, please submit an issue on #{GemMonitor.issues_url} along with your gemfile for the team to address the issue.")
    end

    def extract_gem_version_for gem_name
      raw_gem_version = gemfile_lock_content.scan(/\s{2}#{gem_name} \(\S*\)/).join
      raw_gem_version.scan(/\(\S*\)/).join.gsub("(", "").gsub(")", "")
    end
  end
end
