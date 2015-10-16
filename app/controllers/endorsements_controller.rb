class EndorsementsController < ApplicationController

  def create
    @review = Review.find(params[:review_id])
    @endorsement = @review.build_with_user(current_user)

    if @endorsement.save
      redirect_to restaurants_path
    else
      redirect_to restaurants_path
    end
  end
end
