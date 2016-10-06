describe GemMonitor do
  include GemVersionsHelper
  include OutcallsHelper
  include FilesHelper
  let(:gemfile_path) { "#{GemMonitor.root}/spec/fixtures/gemfiles/Gemfile_1" }
  let(:gemfile_lock_path) { "#{GemMonitor.root}/spec/fixtures/gemfiles/Gemfile_1.lock" }

  it "has a version number" do
    expect(GemMonitor::VERSION).not_to be nil
  end

  describe ".root" do
    it "returns the pwd path" do
      expect(subject.root).to eq FileUtils.pwd
    end
  end

  describe ".main_url" do
    it "returns the repo url" do
      expect(subject.main_url).to eq "https://github.com/rubene/gem_monitor"
    end
  end

  describe ".issues_url" do
    it "returns the repo issues url" do
      expect(subject.issues_url).to eq "https://github.com/rubene/gem_monitor/issues"
    end
  end

  describe ".report_erb_template" do
    it "returns the report erb template path" do
      expect(subject.report_erb_template).to eq "#{FileUtils.pwd}/lib/gem_monitor/templates/index.html.erb"
    end
  end

  describe ".report_file_path" do
    it "returns the report html template path" do
      expect(subject.report_file_path).to eq "gem_monitor/index.html"
    end
  end

  describe ".output_folder_name" do
    it "returns the report folder name" do
      expect(subject.output_folder_name).to eq "gem_monitor"
    end
  end

  describe ".run" do
    after(:all) do
      delete_report_folder
    end

    context "without exception" do
      before(:each) do
        GemMonitor.configure do |gm|
          gm.gemfile_path = gemfile_path
          gm.gemfile_lock_path = gemfile_lock_path
        end
        gem_versions.each do |k, v|
          stub_latest_version_request status: 200, body: "{\"version\":\"#{v[:latest_version]}\"}", gem_name: "#{k}"
        end
      end

      it "creates a report file" do
        subject.run
        expect(File.exist?(GemMonitor.report_file_path)).to eq true
      end
    end

    context "with exception" do
      context "with extractor error" do
        before(:each) do
          allow_any_instance_of(GemMonitor::Extractor).to receive(:project_gems_names).and_return []
        end

        it "creates an exception" do
          expect(STDOUT).to receive(:puts).with("Could not extract gem names from your Gemfile, please submit an issue on #{GemMonitor.issues_url} along with your gemfile for the team to address the issue.".red)
          subject.run
        end
      end
    end
  end

  describe ".configure" do
    before(:each) do
      subject.configure do |gm|
        gm.gemfile_path = gemfile_path
        gm.gemfile_lock_path = gemfile_lock_path
      end
    end

    it "returns a configuration object" do
      expect(subject.configuration).to be_kind_of GemMonitor::Configuration
    end

    it "sets the gemfile_path" do
      expect(subject.configuration.gemfile_path).to eq gemfile_path
    end

    it "sets the gemfile_lock_path" do
      expect(subject.configuration.gemfile_lock_path).to eq gemfile_lock_path
    end
  end
end
