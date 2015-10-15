require 'rails_helper'

feature 'review' do

  before(:each) do
    @user1 = create(:user)
    sign_in(@user1)
    @user2 = create(:user, email: 'test2@email.com')
    @user1.restaurants.create name: 'KFC'
  end

  context 'creating reviews' do
    scenario 'allows a user to leave a review using a form ' do
      create_review
      expect(current_path).to eq('/restaurants')
      expect(page).to have_content('so so')
    end
  end

  context 'deleting reviews' do
    before(:each) do
      create_review
    end

    scenario 'user can delete a review' do
      click_link 'Delete this review'
      expect(page).not_to have_content "so so"
      expect(page).not_to have_link 'Delete this review'
    end

    scenario 'user can only delete their own review' do
      click_link 'Sign out'
      sign_in(@user2)
      expect(page).not_to have_link 'Delete this review'
    end

  end

end
