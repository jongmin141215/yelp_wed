module ReviewsHelper
  def star_rating(rating)
    return rating unless rating.respond_to?(:round)
    remainder = 5 - rating
    r = ('★' * rating.round) + ('☆' * remainder)
  end
end
