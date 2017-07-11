require 'rails_helper'

RSpec.describe "mail_image_requests/edit", type: :view do
  before(:each) do
    @mail_image_request = assign(:mail_image_request, MailImageRequest.create!(
      :type => "",
      :complete => false
    ))
  end

  it "renders the edit mail_image_request form" do
    render

    assert_select "form[action=?][method=?]", mail_image_request_path(@mail_image_request), "post" do

      assert_select "input#mail_image_request_type[name=?]", "mail_image_request[type]"

      assert_select "input#mail_image_request_complete[name=?]", "mail_image_request[complete]"
    end
  end
end
