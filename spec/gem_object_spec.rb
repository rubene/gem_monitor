describe GemMonitor::GemObject do
  include OutcallsHelper

  context "decorator methods" do
    before(:each) do
      subject.name = "wafflessauce"
      subject.latest_version = "9.0.0.0"
      subject.project_version = "5.0.0.0"
    end

    describe "#output_html_class" do
      context "with latest version error" do
        it "returns 'red'" do
          subject.latest_version = "unknown"
          expect(subject.output_html_class).to eq "red"
        end
      end

      context "without latest version error" do
        context "project version is outdated" do
          it "returns 'red'" do
            expect(subject.output_html_class).to eq "red"
          end
        end

        context "project version is not outdated" do
          it "returns 'green'" do
            subject.project_version = "9.0.0.0"
            expect(subject.output_html_class).to eq "green"
          end
        end
      end
    end

    describe "#output_project_version" do
      context "with project version error" do
        it "returns project version error message" do
          subject.project_version = ""
          expect(subject.output_project_version).to eq "Something went wrong finding the project version for #{subject.name} gem"
        end
      end

      context "without project version error" do
        it "returns the project the version" do
          expect(subject.output_project_version).to eq "5.0.0.0"
        end
      end
    end

    describe "#output_latest_version" do
      context "with latest version error" do
        it "returns latest version error message" do
          subject.latest_version = "unknown"
          expect(subject.output_latest_version).to eq "Something went wrong checking the latest version for #{subject.name} gem"
        end
      end

      context "without latest version error" do
        it "returns the lastest the version" do
          expect(subject.output_latest_version).to eq "9.0.0.0"
        end
      end
    end
  end

  describe "#latest_version" do
    before(:each) do
      subject.name = "rails"
    end

    context "without error" do
      it "returns 'unknown'" do
        stub_latest_version_request status: 200
        expect(subject.latest_version).to eq "5.0.0.1"
      end
    end

    context "with error" do
      context "response code is not 200" do
        it "returns 'unknown'" do
          stub_latest_version_request status: 404
          expect(subject.latest_version).to eq "unknown"
        end
      end

      context "error parsing the response" do
        it "raises an exception" do
          stub_latest_version_request status: 200, body: "Pepe Trueno"
          expect{subject.latest_version}.to raise_error GemMonitor::Error
        end
      end
    end
  end
end
