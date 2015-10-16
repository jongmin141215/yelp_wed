require 'spec_helper'

describe Review, type: :model do
  it { is_expected.to belong_to :restaurant }

  it { is_expected.to belong_to :user }

  it "is invalid if the rating is more than 5" do
    review = Review.new(rating: 10)
    expect(review).to have(1).error_on(:rating)
  end

  describe '#average_rating' do
    let(:restaurant) { Restaurant.create(name: 'The Ivy') }

    context 'no reviews' do
      it 'returns "N/A" when there are no reviews' do
        expect(restaurant.average_rating).to eq 'N/A'
      end
    end

    context '1 review' do
      it 'returns that rating' do
        restaurant.reviews.create(rating: 4)
        expect(restaurant.average_rating).to eq 4
      end
    end

    context 'multiple reviews' do
      it 'returns the average' do
        restaurant.reviews.create(rating: 1)
        restaurant.reviews.create(rating: 5)
        expect(restaurant.average_rating).to eq 3
      end
    end
  end
end
