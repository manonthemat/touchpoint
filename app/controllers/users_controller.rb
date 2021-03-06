class UsersController < ApplicationController
  
  before_action :verify_user, only: [:edit, :update, :destroy]

  def show
    @user = User.find(params[:id])
    @contacts = @user.contacts.all.sort_by!{|c| c.lname}
    @touch = Touch.new
    @contact = Contact.new
    
    if @user == current_user
      @user
    elsif current_user
      redirect_to user_path(current_user.id)
    else
      redirect_to new_session_path
    end

    dashboard_touches
  end

  def new
    @user = User.new
    @is_signup = true
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id.to_s
      redirect_to user_path(@user.id)
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to user_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path
  end

private

  def user_params
    params.require(:user).permit(:fname, :lname, :email, :password, :password_confirmation)
  end

  def verify_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path
    end
  end

  #finds all the user touchpoints that should be displayed
  #on the current week's dashboard.
  def dashboard_touches
    @touches = []
    @user.touches.each do |t|
      unless t.is_complete
        @touches.push(t) if t.due_date <= Date.today.end_of_week
      end
    end
    @touches.sort_by!{|t| t.due_date}
  end
  
end
