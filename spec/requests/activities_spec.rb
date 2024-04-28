require 'rails_helper'

RSpec.describe "Activites", type: :request do
  include_context 'logged in user'

  describe "POST /activities/:id/verify_attendance" do
    let(:activity) { create(:activity) }
    let(:past_activity) { create(:activity, :past) }
    let(:future_activity) { create(:activity, :future) }

    context "with correct passcode" do
      it "redirects to the activity page" do
        post verify_attendance_activity_path(activity), params: { passcode_input: activity.passcode }
        expect(response).to redirect_to(activity_path(activity))
        follow_redirect!
        expect(response.body).to include('Passcode is correct')
      end
    end

    context "with incorrect passcode" do
      it "redirects to the activity page with an error message" do
        post verify_attendance_activity_path(activity), params: { passcode_input: activity.passcode + 1 }
        expect(response).to redirect_to(activity_path(activity))
        follow_redirect!
        expect(response.body).to include('Passcode is incorrect')
      end
    end

    context "with a correct passcode and an already created activity participation record" do
      it "redirects to the activity page" do
        activity_participation = create(:activity_participation, user: User.first, activity: activity)
        post verify_attendance_activity_path(activity), params: { passcode_input: activity.passcode }
        expect(response).to redirect_to(activity_path(activity))
        follow_redirect!
        expect(response.body).to include('Passcode is correct')
        activity_participation.reload
        expect(activity_participation.attended).to be true
      end
    end

    context "with a past activity" do
      it "redirects to the activity page with an error message" do
        post verify_attendance_activity_path(past_activity), params: { passcode_input: past_activity.passcode }
        expect(response).to redirect_to(activity_path(past_activity))
        follow_redirect!
        expect(response.body).to include('Passcode is no longer valid')
      end
    end

    context "with a future activity" do
      it "redirects to the activity page with an error message" do
        post verify_attendance_activity_path(future_activity), params: { passcode_input: future_activity.passcode }
        expect(response).to redirect_to(activity_path(future_activity))
        follow_redirect!
        expect(response.body).to include('Passcode is no longer valid')
      end
    end
  end
end
