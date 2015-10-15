class ReviewsController < ApplicationController


  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find params[:restaurant_id]
    @review = @restaurant.build_review review_params, current_user

    if @review.save
      redirect_to restaurants_path
    else
      if @review.errors[:user]
        redirect_to restaurants_path, alert: 'You have already reviewed this restaurant'
      else
        render :new
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])
    if @review.user_id == current_user.id
      @review.destroy
      redirect_to '/restaurants'
    else
      redirect_to '/restaurants', alert: 'You cannot delete this review'
    end
  end

  private

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

end
