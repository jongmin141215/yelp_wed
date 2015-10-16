require 'rails_helper'

feature 'review' do

  def leave_review(thoughts, rating)
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: thoughts
    select rating, from: 'Rating'
    click_button 'Leave Review'
  end

  before(:each) do
    @user1 = create(:user)
    sign_in(@user1)
    @user2 = create(:user, email: 'test2@email.com')
    @user1.restaurants.create name: 'KFC'
  end

  context 'creating reviews' do
    scenario 'allows a user to leave a review using a form ' do
      leave_review('so so', 3)
      expect(current_path).to eq('/restaurants')
      expect(page).to have_content('so so')
    end
  end

  context 'deleting reviews' do
    scenario 'user can delete a review' do
      leave_review('so so', 3)
      click_link 'Delete this review'
      expect(page).not_to have_content "so so"
      expect(page).not_to have_link 'Delete this review'
    end

    scenario 'other users cannnot see the "Delete this review"' do
      leave_review('so so', 3)
      click_link 'Sign out'
      sign_in(@user2)
      expect(page).not_to have_link 'Delete this review'
    end

    scenario 'The user who created the restaurant cannot see delete review link from other users' do
      click_link 'Sign out'
      sign_in(@user2)
      leave_review('so so', 3)
      click_link 'Sign out'
      sign_in(@user1)
      expect(page).not_to have_link 'Delete this review'
    end
  end

  scenario 'displays an average rating for all reviews' do
    leave_review('So so', 3)
    click_link 'Sign out'
    sign_in(@user2)
    leave_review('Greate', 5)
    expect(page).to have_content('Average rating: ★★★★☆')
  end

end
