require 'rails_helper'

describe MailQueue, type: :model do
  let(:mq){ build :mail_queue }

  describe 'Validations' do

  end

  describe 'Associations' do
    it{ should have_many :mail_images }
  end

  describe 'Attributes' do
    specify '#complete should default to false' do
      mq.complete.should == false
    end

    specify '#marked_for_completion should default to false' do
      mq.marked_for_completion.should == false
    end
  end # Associations

  describe 'Methods' do
    let(:c){ create :client }
    let(:mi){ create :mail_image }

    before(:each) do
      mi.mail_queue = mq
      mi.save!
    end

    describe '#mail_images_for(client)' do

      it 'should return an array of images for this Client on this MailQueue' do
        ckm = build(:client_keyword_match)
        ckm.mail_image = mi
        ckm.client = c
        ckm.save!
        mq.mail_images_for(c).should == [mi]
      end
    end

    describe '#cilents' do
      it 'should return all Clients that have a CKM wiht any MailImage' do
        ckm = build(:client_keyword_match)
        ckm.mail_image = mi
        ckm.client = c
        ckm.save!
        mq.clients.should == [c]
      end
    end

    describe '#send_emails' do
      it 'should set #complete to true when complete' do
        # expect{ mq.send_emails }.to change{ mq.complete }.from(false).to(true)
      end

      it 'should return the number of emails sent (which is the same as the number of clients that match)' do
        ckm = build(:client_keyword_match)
        ckm.mail_image = mi
        ckm.client = c
        ckm.save!
        mq.send_emails.should == 1
      end
    end

    describe '#name' do
      it 'exists' do
        mq.name.should_not == nil
      end
    end

  end # Methods

  describe 'Scopes' do
    before(:each) do
      mq.save!
    end

    describe '#complete' do
      it 'should return only complete MailQueues' do
        complete_mq = create(:mail_queue, complete: true)
        MailQueue.complete.count.should == 1
        MailQueue.complete.first.should == complete_mq
      end
    end

    describe '#incomplete' do
      it 'should return only incomplete MailQueues' do
        complete_mq = create(:mail_queue, complete: true)
        MailQueue.complete.count.should == 1
        MailQueue.incomplete.first.should == mq
      end
    end

    describe '#marked_for_completion' do
      it 'should return MailQueues marked_for_completion, if they are incomplete' do
        complete_mq = create(:mail_queue, complete: true, marked_for_completion: true)
        incomplete_mq = create(:mail_queue, marked_for_completion: true)
        MailQueue.complete.count.should == 1
        MailQueue.marked_for_completion.first.should == incomplete_mq
      end
    end
  end # Scopes
end
