require 'rails_helper'

feature 'restaurants' do

  before(:each) do
    @user = create(:user)
    sign_in(@user)
    @user2 = create(:user2)
  end

  context'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content('No restaurants yet')
      expect(page).to have_link('Add a restaurant')
    end
  end

  context 'restaurants have been added' do
    scenario 'display restaurants' do
      @user.restaurants.create name: 'KFC'
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill in a form, then dsiplays new restaurant' do
      create_restaurant('KFC')
      expect(page).to have_content('KFC')
      expect(current_path).to eq('/restaurants')
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        create_restaurant('kf')
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do
    scenario 'lets a user view a restaurant' do
      restaurant = @user.restaurants.create name: 'KFC'
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq("/restaurants/#{restaurant.id}")
    end
  end


  context 'editing restaurants' do
    scenario 'let a user edit a restaurant' do
      @user.restaurants.create name: 'KFC'
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'users can only edit their own restaurants' do
      restaurant = @user.restaurants.create name: 'KFC'
      visit '/restaurants'
      click_link 'Sign out'
      sign_in(@user2)
      expect(page).not_to have_link 'Edit KFC'
    end
  end

  context 'deleting restaurants' do
    scenario 'removes a restaurant when a user clicks a delete link' do
      @user.restaurants.create name: 'KFC'
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'user can only delete their own restaurant' do
      @user.restaurants.create name: 'KFC'
      visit '/restaurants'
      click_link 'Sign out'
      sign_in(@user2)
      expect(page).not_to have_link 'Delete KFC'
    end
  end

  context 'user not signed in' do

    scenario 'user must be signed in to create a restaurant' do
      visit '/restaurants'
      click_link 'Sign out'
      click_link 'Add a restaurant'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(current_path).to eq '/users/sign_in'
    end
  end



end
