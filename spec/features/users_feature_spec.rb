require 'rails_helper'

feature "User can sign in and out" do
  context "user not signed in and on the homepage" do
    it "should see a 'sign in' link and a 'sign up' link" do
      visit('/')
      expect(page).to have_link('Sign in')
      expect(page).to have_link('Sign up')
    end

    it "should not see 'sign out' link" do
      visit('/')
      expect(page).not_to have_link('Sign out')
    end
  end

  context "user signed in on the homepage" do
    before do
      visit('/')
      click_link('Sign up')
      fill_in('Email', with: 'test@example.com')
      fill_in('Password', with: 'testtest')
      fill_in('Password confirmation', with: 'testtest')
      click_button('Sign up')
    end

    it "should see 'sign out' link" do
      visit('/')
      expect(page).to have_link('Sign out')
    end

    it "should not see a 'sign in' link and a 'sign up' link" do
      visit('/')
      expect(page).not_to have_link('Sign in')
      expect(page).not_to have_link('Sign up')
    end
  end
end

feature 'Users can only review a restaurant once' do
  scenario 'it does not allow the user to add another review to the same restaurant' do
    user = FactoryGirl.create(:user)
    visit '/users/sign_in'
    fill_in 'Email', with: 'test@email.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'

    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'so so'
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(page).not_to have_link 'Review KFC'
  end
end
