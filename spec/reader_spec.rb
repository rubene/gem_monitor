describe GemMonitor::Reader do
  describe "#read" do
    context "file path is not nil" do
      context "file path does not exists" do
        it "raises an exception" do
          subject.file_path = "somewhere/over/the/rainbow.lock"
          expect{subject.read}.to raise_error GemMonitor::Error
        end
      end

      context "file path does exists" do
        it "returns the contents of the file on a string" do
          subject.file_path = "#{GemMonitor.root}/spec/fixtures/gemfiles/Gemfile_1"
          expect(subject.read).to be_kind_of String
        end
      end
    end

    context "file path is nil" do
      it "raises an exception" do
        expect{subject.read}.to raise_error GemMonitor::Error
      end
    end
  end
end
