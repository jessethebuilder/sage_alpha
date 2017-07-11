require 'rails_helper'

describe 'Client Requests', type: :feature, js: false do
  describe 'Creating a Client' do
    it 'should create a User' do
      sign_in_admin

      visit '/clients/new'
      fill_in_client_min
      expect{ click_button 'Create Client' }.to change{ User.count }.by(1)
    end
  end
  # describe 'As a User' do
  #
  # end
  #
  # describe 'As an Admin' do
  #
  # end
end
