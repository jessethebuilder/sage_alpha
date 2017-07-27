require 'rails_helper'

describe ClientKeywordMatch, type: :model do
  let(:ckm){ build :client_keyword_match }

  describe 'Valildations' do
    it{ should validate_presence_of :client }
    it{ should validate_presence_of :keyword }
    it{ should validate_presence_of :mail_image }
  end

  describe 'Associations' do
    it{ should belong_to :client }
    it{ should belong_to :mail_image }
  end

  describe 'Attributes' do
    specify '#email_sent should default to false' do
      ckm.email_sent.should == false
    end
  end

  describe 'Idioms' do
    describe 'Only one ClientKeywordMatch per Mail Image' do
      it 'should not create additional ckms if one exists' do
        ckm.save
        new_ckm = build(:client_keyword_match)
        new_ckm.mail_image = ckm.mail_image
        expect{ new_ckm.save }.not_to change{ ClientKeywordMatch.count }
      end

      it 'should destroy previous ckm' do
        ckm.save
        new_ckm = build(:client_keyword_match)
        new_ckm.mail_image = ckm.mail_image
        new_ckm.save

        ClientKeywordMatch.where(id: ckm.id).count.should == 0
      end
    end
  end
end
