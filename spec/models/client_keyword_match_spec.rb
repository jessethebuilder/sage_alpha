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
end
