require 'rails_helper'

RSpec.describe "mail_image_requests/new", type: :view do
  before(:each) do
    assign(:mail_image_request, MailImageRequest.new(
      :type => "",
      :complete => false
    ))
  end

  it "renders new mail_image_request form" do
    render

    assert_select "form[action=?][method=?]", mail_image_requests_path, "post" do

      assert_select "input#mail_image_request_type[name=?]", "mail_image_request[type]"

      assert_select "input#mail_image_request_complete[name=?]", "mail_image_request[complete]"
    end
  end
end
