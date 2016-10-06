describe GemMonitor::Service do
  include OutcallsHelper
  describe ".get_latest_version_for" do
    context "without error" do
      it "returns 'unknown'" do
        stub_latest_version_request status: 200
        expect(subject.class.get_latest_version_for("rails")).to eq "5.0.0.1"
      end
    end

    context "with error" do
      context "response code is not 200" do
        it "returns 'unknown'" do
          stub_latest_version_request status: 404
          expect(subject.class.get_latest_version_for("rails")).to eq "unknown"
        end
      end

      context "error parsing the response" do
        it "raises an exception" do
          stub_latest_version_request status: 200, body: "Pepe Trueno"
          expect{subject.class.get_latest_version_for("rails")}.to raise_error GemMonitor::Error
        end
      end
    end
  end
end
