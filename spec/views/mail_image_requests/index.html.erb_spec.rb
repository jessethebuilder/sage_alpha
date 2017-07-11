require 'rails_helper'

RSpec.describe "mail_image_requests/index", type: :view do
  before(:each) do
    assign(:mail_image_requests, [
      MailImageRequest.create!(
        :type => "Type",
        :complete => false
      ),
      MailImageRequest.create!(
        :type => "Type",
        :complete => false
      )
    ])
  end

  it "renders a list of mail_image_requests" do
    render
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
