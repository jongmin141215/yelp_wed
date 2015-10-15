class RestaurantsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.build_with_user(restaurant_params, current_user)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user_id == current_user.id
      @restaurant.update(restaurant_params)
      redirect_to '/restaurants', notice: 'Restaurant updated successfully'
    else
      redirect_to '/restaurants', alert: 'You can only edit your own restaurant'
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user_id == current_user.id
      @restaurant.destroy
      redirect_to '/restaurants', notice: 'Restaurant deleted successfully'
    else
      redirect_to '/restaurants', alert: 'You can only delete your own restaurants'
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end


end
