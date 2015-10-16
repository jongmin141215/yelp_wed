class Review < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user
  has_many :endorsements
  validates :rating, inclusion: (1..5)
  validates :user, uniqueness: { scope: :restaurant, message: 'has reviewed this restaurant already' }

  def build_with_user(user)
    endorsement = endorsements.build
    endorsement.user = user
    endorsement
  end

end
