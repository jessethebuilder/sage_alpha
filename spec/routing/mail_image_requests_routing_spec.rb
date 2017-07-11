require "rails_helper"

RSpec.describe MailImageRequestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/mail_image_requests").to route_to("mail_image_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/mail_image_requests/new").to route_to("mail_image_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/mail_image_requests/1").to route_to("mail_image_requests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/mail_image_requests/1/edit").to route_to("mail_image_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/mail_image_requests").to route_to("mail_image_requests#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/mail_image_requests/1").to route_to("mail_image_requests#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/mail_image_requests/1").to route_to("mail_image_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/mail_image_requests/1").to route_to("mail_image_requests#destroy", :id => "1")
    end

  end
end
