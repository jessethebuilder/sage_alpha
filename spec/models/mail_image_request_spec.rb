require 'rails_helper'

RSpec.describe MailImageRequest, type: :model do
  let(:mir){ create :mail_image_request }

  describe 'Validations' do
    it{ should validate_presence_of :type }
    it{ should validate_inclusion_of(:type).in_array(MailImageRequest::TYPES) }
    it{ should validate_presence_of :client }
    it{ should validate_presence_of :mail_image }
  end

  describe 'Associaions' do
    it{ should belong_to :client }
    it{ should belong_to :mail_image }
  end

  describe 'Idioms' do 
    describe "Complete" do
      specify '#complete should default as false' do
        mir.complete.should == false
      end

      specify '#completed_at should be set when saved as "complete"' do
        mir.completed_at.should == nil
        mir.update_attribute(:complete, true)
        mir.completed_at.should_not == nil
      end

      specify "#completed_at should be set to nil when saved when #complete == false" do
        mir.update_attribute(:complete, true)
        mir.completed_at.should_not == nil
        mir.update_attribute(:complete, false)
        mir.completed_at.should == nil
      end
    end

  end # Idioms

  describe 'Scopes' do
    describe 'compelete' do
      specify ':complete should only return complete MIRs' do
        mir.save!
        complete_mir = create(:mail_image_request, complete: true)
        MailImageRequest.complete.count.should == 1
        MailImageRequest.complete.first.should == complete_mir
      end
    end
  end
end
