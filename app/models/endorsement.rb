class Endorsement < ActiveRecord::Base
  belongs_to :review
  belongs_to :user
  validates :user, uniqueness: { scope: :review }
end
