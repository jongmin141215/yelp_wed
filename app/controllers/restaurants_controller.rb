class RestaurantsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  # def create
  #   @restaurant = Restaurant.find params[:restaurant_id]
  #   redirect_to '/restaurants'
  # end

  def restaurant_params
    params.require(:restaurant).permit(:name)
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
      flash[:notice] = 'Restaurant updated successfully'
      redirect_to '/restaurants'
    else
      flash[:notice] = 'You can only edit your own restaurant'
      redirect_to '/restaurants'
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user_id == current_user.id
      @restaurant.destroy
      flash[:notice] = 'Restaurant deleted successfully'
      redirect_to '/restaurants'
    else
      flash[:notice] = 'You can only delete your own restaurants'
      redirect_to '/restaurants'
    end
  end

  def create
    @restaurant = Restaurant.build_with_user(restaurant_params, current_user)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

end
