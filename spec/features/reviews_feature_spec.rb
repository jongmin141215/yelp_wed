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

  # context 'deleting reviews' do
  #   scenario 'user can delete their own reviews' do
  #     @user1.
  #
  #   end
  # end

end
