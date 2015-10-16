class EndorsementsController < ApplicationController

  def index
    redirect_to restaurants_path
  end

  def create
    @review = Review.find(params[:review_id])
    @endorsement = @review.build_with_user(current_user)

    if @endorsement.save
      render json: { new_endorsement_count: @review.endorsements.length }

    else
      redirect_to restaurants_path
    end
  end
end
