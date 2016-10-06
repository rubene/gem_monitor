module GemMonitor
  class Service
    BASE_URL = "https://rubygems.org"
    VERSIONS_ENDPOINT = "/api/v1/versions/"

    # TODO: create an oject to handle this response
    #def self.get_gem_versions_for gem_name
    #  RestClient.get "#{BASE_URL}#{VERSIONS_ENDPOINT}#{gem_name}.json"
    #end

    # TODO: create an oject to handle this response
    def self.get_latest_version_for gem_name
      begin
        response = RestClient.get("#{BASE_URL}#{VERSIONS_ENDPOINT}#{gem_name}/latest.json")
        JSON.parse(response.body).fetch("version")
      rescue RestClient::Exception => e
        "unknown"
      rescue JSON::ParserError => e
        raise GemMonitor::Error.new("Error parsing response please submit an issue on #{GemMonitor.issues_url} along the response #{response.body}")
      end
    end
  end
end
