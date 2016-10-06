describe GemMonitor::Extractor do
  include GemVersionsHelper
  include OutcallsHelper
  let(:gemfile_path) { "#{GemMonitor.root}/spec/fixtures/gemfiles/Gemfile_1" }
  let(:gemfile_lock_path) { "#{GemMonitor.root}/spec/fixtures/gemfiles/Gemfile_1.lock" }

  before(:each) do
    GemMonitor.configure do |gm|
      gm.gemfile_path = gemfile_path
      gm.gemfile_lock_path = gemfile_lock_path
    end
  end

  describe "#gemfile_content" do
    context "file path exists" do
      it "returns the gemfile content as a string" do
        expect(subject.gemfile_content).to be_kind_of String
      end
    end

    context "file path does not exists" do
      it "raises an exception" do
        GemMonitor.configuration.gemfile_path = "somewhere/over/the/rainbow/Gemfile"
        expect{subject.gemfile_content}.to raise_error GemMonitor::Error
      end
    end
  end


  describe "#gemfile_lock_content" do
    context "file path exists" do
      it "returns the gemfile lock content as a string" do
        expect(subject.gemfile_lock_content).to be_kind_of String
      end
    end

    context "file path does not exists" do
      it "raises an exception" do
        GemMonitor.configuration.gemfile_lock_path = "somewhere/over/the/rainbow/Gemfile.lock"
        expect{subject.gemfile_lock_content}.to raise_error GemMonitor::Error
      end
    end
  end

  describe "#extract_project_gem_objects" do
    context "without issues parsing Gemfile" do
      before(:each) do
        gem_versions.each do |k, v|
          stub_latest_version_request status: 200, body: "{\"version\":\"#{v[:latest_version]}\"}", gem_name: "#{k}"
        end
      end

      it "returns an array" do
        expect(subject.extract_project_gem_objects).to be_kind_of Array
      end

      it "contains gem_objects" do
        expect(subject.extract_project_gem_objects.first).to be_kind_of GemMonitor::GemObject
      end
    end

    context "with issues parsing Gemfile" do
      before(:each) do
        allow_any_instance_of(GemMonitor::Extractor).to receive(:project_gems_names).and_return []
      end

      it "raises an exception" do
        expect{subject.extract_project_gem_objects}.to raise_error GemMonitor::Error
      end
    end
  end
end
