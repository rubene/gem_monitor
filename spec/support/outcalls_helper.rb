module OutcallsHelper
  def stub_latest_version_request args = {}
    gem_name = args.fetch(:gem_name, "rails")
    status = args.fetch(:status, 200)
    body = args.fetch(:body, "{\"version\":\"5.0.0.1\"}")
    stub_request(:get, "https://rubygems.org/api/v1/versions/#{gem_name}/latest.json").to_return(status: status, body: body)
  end
end
