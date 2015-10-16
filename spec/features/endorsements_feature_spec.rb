require 'rails_helper'

feature 'endorsing reviews' do
  before do
    @user = create(:user)
    sign_in(@user)
    @user2 = create(:user2)
    kfc = Restaurant.create(name: 'KFC')
    kfc.reviews.create(rating: 3, thoughts: 'It was an abomination')
    # @review = @user.reviews.create(rating: 3, thoughts: 'It was an abomination')
  end

  scenario 'a user can endorse a review, which updates the review endorsement count', js: true do
    visit '/restaurants'
    click_link 'Endorse Review'
    expect(page).to have_content '1 endorsement'
  end

  scenario 'a user can only endorse a review once', js: true do
    visit '/restaurants'
    click_link 'Endorse Review'
    click_link 'Endorse Review'
    expect(page).to have_content '1 endorsement'
  end

  scenario 'other users can endorse a review that they have not endorsed', js: true do
    visit '/restaurants'
    click_link 'Endorse Review'
    click_link 'Sign out'
    sign_in(@user2)
    click_link 'Endorse Review'
    expect(page).to have_content '2 endorsement'
  end

  # scenario 'when a user endorses a review, "Endorse Review" link disappers' do
  #   visit '/restaurants'
  #   click_link 'Endorse Review'
  #   expect(page).not_to have_link 'Endorse Review'
  # end
end
