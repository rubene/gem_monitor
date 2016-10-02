module GemMonitor
  class Extractor
    attr_accessor :gem_objects
    attr_reader :gemfile_content, :gemfile_lock_content

    def initialize args = {}
      self.gem_objects = []
    end

    def gemfile_content
      @gemfile_content ||= read_gemfile
    end

    def gemfile_lock_content
      @gemfile_content ||= read_gemfile_lock
    end

    def extract_project_gems
      extract_gems_from_gemfile
      gem_objects
    end

  private

    def read_gemfile
      GemMonitor::Reader.read "Gemfile"
    end

    def read_gemfile_lock
      GemMonitor::Reader.read "Gemfile.lock"
    end

    def project_gems_names
      (read_gemfile.scan(/^\s*gem "(.*?)"/) + read_gemfile.scan(/^\s*gem '(.*?)'/)).flatten
    end

    def extract_gems_from_gemfile
      gem_names_from_gemfile = project_gems_names
      raise_project_name_error if gem_names_from_gemfile.empty?
      gem_names_from_gemfile.each do |project_gem_name|
        self.gem_objects.push GemObject.new(name: project_gem_name, project_version: extract_gem_version_for(project_gem_name))
      end
    end

    def raise_project_name_error
      raise GemMonitor::Error.new("Could not extract gem names from your Gemfile, please submit an issue on github along with your gemfile for the team to address the issue.")
    end

    def extract_gem_version_for gem_name
      raw_gem_version = gemfile_lock_content.scan(/\s{2}#{gem_name} \(\S*\)/).join
      raw_gem_version.scan(/\(\S*\)/).join.gsub("(", "").gsub(")", "")
    end
  end
end
