module GemMonitor
  class Service
    BASE_URL = "https://rubygems.org"
    VERSIONS_ENDPOINT = "/api/v1/versions/"

    # TODO: create an oject to handle this response
    def self.get_gem_versions_for gem_name
      RestClient.get "#{BASE_URL}#{VERSIONS_ENDPOINT}#{gem_name}.json"
    end

    # TODO: create an oject to handle this response
    def self.get_latest_version_for gem_name
      response = RestClient.get("#{BASE_URL}#{VERSIONS_ENDPOINT}#{gem_name}/latest.json")
      if response.code == 200
        JSON.parse(response.body).fetch("version")
      else
        "0.0.0"
      end
    end
  end
end
