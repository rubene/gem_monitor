describe GemMonitor::Inspector do
  include GemVersionsHelper
  include OutcallsHelper
  include FilesHelper

  let(:gemfile_path) { "#{GemMonitor.root}/spec/fixtures/gemfiles/Gemfile_1" }
  let(:gemfile_lock_path) { "#{GemMonitor.root}/spec/fixtures/gemfiles/Gemfile_1.lock" }

  before(:each) do
    GemMonitor.configure do |gm|
      gm.gemfile_path = gemfile_path
      gm.gemfile_lock_path = gemfile_lock_path
    end
    gem_versions.each do |k, v|
      stub_latest_version_request status: 200, body: "{\"version\":\"#{v[:latest_version]}\"}", gem_name: "#{k}"
    end
  end

  describe "#project_gems" do
    it "returns an array" do
      expect(subject.project_gems).to be_kind_of Array
    end

    it "contains gem_objects" do
      expect(subject.project_gems.first).to be_kind_of GemMonitor::GemObject
    end
  end

  describe "#scan" do
    context "#create_report_folder" do
      before(:each) do
        allow_any_instance_of(GemMonitor::Inspector).to receive(:create_report_file)
      end

      context "report folder does not exists" do
        it "creates the folder" do
          allow(Dir).to receive(:exists?).and_return false
          expect(FileUtils).to receive(:mkdir).with GemMonitor.output_folder_name
          subject.scan
        end
      end

      context "report folder does exists" do
        it "creates the folder" do
          allow(Dir).to receive(:exists?).and_return true
          expect(FileUtils).to_not receive(:mkdir).with GemMonitor.output_folder_name
          subject.scan
        end
      end
    end

    context "#create_report_file" do
      # clean files
      after(:all) do
        delete_report_folder
      end

      it "creates the file" do
        expect(File).to receive(:open).with(GemMonitor.report_file_path, "w")
        subject.scan
      end

      it "writes to the file" do
        subject.scan
        expect(File.exist?(GemMonitor.report_file_path)).to eq true
      end
    end
  end
end
