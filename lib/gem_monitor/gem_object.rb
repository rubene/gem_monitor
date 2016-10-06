module GemMonitor
  class GemObject

    attr_accessor :name, :project_version, :latest_version

    LATEST_VERSION_ERRORS = ["unknown"]

    def latest_version
      @latest_version ||= get_gem_latest_version
    end

    def initialize(args = {})
      self.name = args.fetch(:name, "")
      self.project_version = args.fetch(:project_version, "")
    end

    # TODO: maybe move this to a decorator but debating into
    #       adding another run dependency.
    def output_html_class
      return "red" if latest_version_error?
      project_version < latest_version ? "red" : "green"
    end

    def output_project_version
      project_version.empty? ? project_version_error_message : project_version
    end

    def output_latest_version
      latest_version_error? ? latest_version_error_message : latest_version
    end

  private

    def latest_version_error?
      return true if LATEST_VERSION_ERRORS.include? latest_version
      false
    end

    def latest_version_error_message
      "Something went wrong checking the latest version for #{name} gem"
    end

    def project_version_error_message
      "Something went wrong finding the project version for #{name} gem"
    end

    def get_gem_latest_version
      GemMonitor::Service.get_latest_version_for name
    end
  end
end
