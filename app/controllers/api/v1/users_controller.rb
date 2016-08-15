module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy, :microposts_count, :following_count, :followers_count]
      before_action :authenticate_jwt, only: [:index, :update, :destroy]
      before_action :correct_user, only: [:update]
      before_action :admin_user, only: :destroy

      # GET /users
      def index
        render json: paginate(User)
      end

      # GET /users/1
      def show
        render json: @user
      end

      # POST /users
      def create
        @user = User.new(signup_user_params)

        if @user.save
          render plain: get_token_by_user(@user)
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /users/1
      def update
        if @user.update(signup_user_params)
          render plain: get_token_by_user(@user)
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # DELETE /users/1
      def destroy
        @user.destroy
      end

      # POST /users/login
      def login
        user = User.find_by(email: params[:email].downcase)
        if user
          if user.authenticate(params[:password])
            render plain: get_token_by_user(user)
          else
            render plain: "密码错误, 请重新输入", status: :unprocessable_entity
          end
        else
          render plain: "账号不存在, 请重新输入", status: :unprocessable_entity
        end
      end

      #GET /users/1/microposts_count
      def microposts_count
        render json: @user.microposts.count
      end

      #GET /users/1/following_count
      def following_count
        render json: @user.following.count
      end

      #GET /users/1/followers_count
      def followers_count
        render json: @user.followers.count
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def user_params
          params.require(:user).permit(:name, :email)
        end

        def signup_user_params
          params.permit(:name, :email, :password, :password_confirmation)
        end

        def correct_user
          @user = User.find(params[:id])
          return unauthorize_error unless current_user?(@user)
        end

        #  确保是管理员
        def admin_user
          return unauthorize_error unless current_user.admin?
        end
    end
  end
end
