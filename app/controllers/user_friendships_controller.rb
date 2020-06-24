class UserFriendshipsController < ApplicationController
  before_action :set_userfriendship, only: %i[show edit update destroy]

  def index
    @user_friendships = UserFriendship.all
  end

  def new
    @user_friendship = UserFriendship.new
  end

  def create
    if current_user.invite(params[:id])
      flash[:notice] = 'Your friend request has been sent'
    else
      flash[:alert] = 'Your request cannot be process, try again later'
    end
    redirect_back fallback_location: users_path
  end

  def destroy
    @user_inverse = UserFriendship.where(user_id: @user_friendship.friend_id, friend_id: @user_friendship.user_id).first
    if @user_friendship.destroy
      flash[:notice] = 'You have deleted your friendship :(' if @user_inverse.destroy
    else
      flash[:alert] = 'Your request cannot be process, try again later'
    end
    redirect_back fallback_location: users_path
  end

  def edit; end

  def update
    if UserFriendship.update_friendship(@user_friendship.user_id, @user_friendship.friend_id, params[:status])
      flash[:notice] = 'You responded to this invitation'
    else
      flash[:alert] = 'You cannot respond to this invitation right now please try again later'
    end
    redirect_back fallback_location: current_user
  end

  private

  def set_userfriendship
    @user_friendship = UserFriendship.find(params[:id])
  end

  def user_friendship_params
    params.require(:user_friendship).permit(:user_id, :friend_id, :status)
  end
end
