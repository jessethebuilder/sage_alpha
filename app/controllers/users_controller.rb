class UsersController < ApplicationController
  before_action :authenticate_admin!, except: [:unknown]
  before_action :set_user, only: [:promote, :demote, :destroy]

  def create
    @user = User.new(user_params)
    @user.password = "#{Faker::Lorem.word}-#{Faker::Lorem.word}-#{Random.rand(1000..9999)}"
    @user.save
    redirect_to users_path, notice: "#{@user.email} has been saved as user"
  end

  def index
    # @users = User.all.order(updated_at: :desc)
    @users = User.clientless.order(updated_at: :desc)

    @user = User.new
  end

  def promote
    @user.update(admin: true)
    # @user.admin = true
    # @user.save
    redirect_to users_path, notice: "#{@user.email} was Promoted to Admin"
  end

  def demote
    @user.update(admin: false)
    redirect_to users_path, notice: "#{@user.email} was Demoted to User"
  end

  def destroy
    name = @user.email
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_path, notice: "#{name} was deleted!" }
      # format.json { head :no_content }
    end
  end

  def unknown
    # root route and currently the only route available to non-users
    if user_signed_in?
      if current_user.admin?
        redirect_to mail_queues_path
      else
        redirect_to client_path(current_user.client)
      end
    else
      redirect_to new_user_session_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
