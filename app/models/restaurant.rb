class Restaurant < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  belongs_to :user
  validates :name, length: {minimum: 3}, uniqueness: true

  def build_review params, user
    self.reviews.create(thoughts: params["thoughts"], rating: params["rating"], user_id: user.id)
  end

  def self.build_with_user(params, user)
    self.new(name: params['name'], user_id: user.id)
  end

  def average_rating
    return 'N/A' if reviews.none?
    average = reviews.inject(0) { |memo, review| memo + review.rating } / reviews.length
  end
end
