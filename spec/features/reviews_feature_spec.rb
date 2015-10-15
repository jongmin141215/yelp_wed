require 'rails_helper'



feature 'review' do

  before(:each) do
    @user1 = create(:user)
    visit '/users/sign_in'
    fill_in 'Email', with: 'test@email.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
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
    before(:each) do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
    end


    scenario 'user can delete a review' do
      click_link 'Delete this review'
      expect(page).not_to have_content "so so"
      expect(page).not_to have_link 'Delete this review'
    end

    scenario 'user can only delete their own review' do
      click_link 'Sign out'
      @user2 = create(:user2)
      visit '/users/sign_in'
      fill_in 'Email', with: 'test2@email.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      expect(page).not_to have_link 'Delete this review'
    end

  end

end
