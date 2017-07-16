require 'rails_helper'

describe Client, type: :model do
  let(:c){ build(:client) }

  describe 'Validations' do
    it{ should validate_presence_of :name }
    it{ should validate_presence_of :email }
    it{ should validate_uniqueness_of :email }
    it{ should validate_presence_of :keywords }
  end

  describe 'Associations' do
    it{ should have_many(:client_keyword_matches) }
    it{ should have_many(:mail_image_requests) }
    it{ should belong_to(:user) }
    it{ should have_many(:mail_queues) }
    # it{ should have_and_belong_to_many(:mail_images) }

    describe 'Dependencies' do
      describe 'MailImageRequests' do
        it 'should delete MailImageRequests on destroy' do
          mir = create(:mail_image_request)
          mir.client.destroy
          mir.persisted?.should == false
        end

        it 'should delete even if MIR is marked as "complete"' do
          mir = create(:completed_mail_image_request)
          mir.client.destroy
          mir.persisted?.should == false
        end
      end

      it 'should delete ClientKeywordMatches on destroy' do
        ckm = create(:client_keyword_match)
        ckm.client.destroy
        ckm.persisted?.should == false
      end
    end
  end

  describe 'Methods' do
    describe '#display_keywords' do
      it 'should return a comma delinimated list of the keywords' do
        c.keywords = %w|have a nice day|
        c.display_keywords.should == 'have, a, nice, day'
      end
    end

    describe '#keywords=' do
      it 'expects a string, deliniated by commas, which it sets as :keywords (array)' do
        c.keywords = 'have, a, nice, day'
        c.keywords.should == %w|have a nice day|
      end

      it 'does not care if there is a space after the comma' do
        c.keywords = 'have,a, nice,day'
        c.keywords.should == %w|have a nice day|
      end

      it 'also accepts an array' do
        c.keywords = %w|have a nice day|
        c.keywords.should == %w|have a nice day|
      end
    end # keywords=


    describe '#mail_images' do
      it 'should return MailImages for the client via ClientKeywordMatches' do
        ckm = create(:client_keyword_match)
        ckm.client.mail_images.should == [ckm.mail_image]
      end 
    end

    describe '#send_email' do
      #jfx PENDING!!!!
    end

  end # Methods

  describe "Idioms" do
    describe "The Client's User" do
      # The User is added to give Client Devise capiblities.
      it "should save a User on creation" do
        expect{ c.save }.to change{ User.count }.by(1)
      end

      it "should update a User's email after save" do
        c.email = "anew@email.com"
        c.save
        c.user.email.should == "anew@email.com"
      end
    end
  end # Idioms
end
