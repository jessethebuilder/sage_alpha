require 'rails_helper'

describe MailImage, type: :model do
  let(:mi){ build :mail_image }

  describe 'Validations' do
    it{ should validate_presence_of :mail_queue }
    it{ should validate_presence_of :image }
  end

  describe 'Associaions' do
    it{ should belong_to :mail_queue }
    it{ should have_many :client_keyword_matches }
    it{ should have_many :mail_image_requests }
  end

  describe 'Methods' do
    let!(:c){ create :client, keywords: %w|hello goodbye| }

    describe '#match_to_clients' do
      it "should only craete 1 match, even if more values match" do
        mi.update_attribute(:text, "hello,fa dfi djiff;;a;s fao   goodbye")
        expect{ mi.match_to_clients }.to change{ ClientKeywordMatch.count }.by(1)
      end
    end

    describe '#clients' do
      it 'should return all clients associated with this MailImage through ClientKeyWorddMatches' do
        c2 = create(:client, keywords: "this, thing")
        mi.update_attribute(:text, 'hello; this')
        mi.match_to_clients
        mi.clients.count.should == 2
      end
    end
  end # Methods
end
