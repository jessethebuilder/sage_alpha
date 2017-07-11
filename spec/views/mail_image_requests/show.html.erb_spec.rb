require 'rails_helper'

RSpec.describe "mail_image_requests/show", type: :view do
  before(:each) do
    @mail_image_request = assign(:mail_image_request, MailImageRequest.create!(
      :type => "Type",
      :complete => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/false/)
  end
end
