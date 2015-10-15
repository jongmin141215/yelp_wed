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
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
      expect(current_path).to eq('/restaurants')
      expect(page).to have_content('so so')
    end
  end

  context 'deleting reviews' do
  
    scenario 'user can delete a review' do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
      click_link 'Delete this review'
      expect(page).not_to have_content "so so"
      expect(page).not_to have_link 'Delete this review'
    end

    scenario 'other users cannnot see the "Delete this review"' do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
      click_link 'Sign out'
      sign_in(@user2)
      expect(page).not_to have_link 'Delete this review'
    end

    scenario 'The user who created the restaurant cannot see delete review link from other users' do
      click_link 'Sign out'
      sign_in(@user2)
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
      click_link 'Sign out'
      sign_in(@user1)
      expect(page).not_to have_link 'Delete this review'
    end


  end

end
