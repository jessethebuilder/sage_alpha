require 'rails_helper'

describe 'Client Requests', type: :feature, js: false do
  let!(:c){ create :client }

  describe 'Show' do
    describe 'As a signed in Client' do

      before(:each) do
        sign_in_client(c)
        visit "clients/#{c.to_param}"
      end

      describe 'MailImages' do
        let(:mi){ create :mail_image }

        before(:each) do
          client.mail_images << mail_image
        end

        describe 'MailImageRequests' do
          let(:mir){ create :mail_image_request }

          before(:each) do
            mir.client = c
            mir.mail_image = mi
            mir.save!
          end

          specify 'A MailImage with no existing requests should show 3 options' do
            within("#mail_image_row_#{mir.to_param}") do
              page.should have_css('.btn')
            end

          end

          specify 'If an MailImageRequest is type "disposal" or "forward" AND makred as "complete"
                   for this MailImage, do not show MailImageRequest creation options' do

          end

        end

      end # MailImages
    end # Signed in
  end # Show

end
