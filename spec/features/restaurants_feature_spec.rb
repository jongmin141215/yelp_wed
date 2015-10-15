require 'rails_helper'

feature 'restaurants' do

  before(:each) do
    @user = FactoryGirl.create(:user)
    visit '/users/sign_in'
    fill_in 'Email', with: 'test@email.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
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
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content('KFC')
      expect(current_path).to eq('/restaurants')
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

      @user2 = create(:user2)
      visit '/users/sign_in'
      fill_in 'Email', with: 'test2@email.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      expect(page).not_to have_link 'Delete KFC'
    end
  end

  context 'creating restaurants' do

    context 'an invalid restaurant' do
        it 'does not let you submit a name that is too short' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'kf'
          click_button 'Create Restaurant'
          expect(page).not_to have_css 'h2', text: 'kf'
          expect(page).to have_content 'error'
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

    # before {Restaurant.create name: 'KFC'} # need a way of associating this creat with a user
    # scenario 'user tries to edit a restaurant that they did not add' do
    #   visit '/restaurants'
    #
    # end
  end


end
