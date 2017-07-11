require 'rails_helper'

RSpec.describe "MailImageRequests", type: :request do
  describe "GET /mail_image_requests" do
    it "works! (now write some real specs)" do
      get mail_image_requests_path
      expect(response).to have_http_status(200)
    end
  end
end
