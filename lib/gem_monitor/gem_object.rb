module GemMonitor
  class GemObject

    attr_accessor :name, :project_version, :latest_version

    LATEST_VERSION_ERRORS = ["unknown", "0.0.0"]

    def latest_version
      @latest_version ||= get_gem_latest_version
    end

    def initialize(args = {})
      self.name = args.fetch(:name, "")
      self.project_version = args.fetch(:project_version, "")
      latest_version
      self.latest_version = output_latest_version
    end

    # decorator methods
    def output_class
      return "red" if latest_version_error?
      project_version < latest_version ? "red" : "green"
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
      "Something went wrong checking latest version for #{name} gem"
    end

    def get_gem_latest_version
      GemMonitor::Service.get_latest_version_for name
    end
  end
end
