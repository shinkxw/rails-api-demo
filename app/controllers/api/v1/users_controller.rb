module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]

      # GET /users
      def index
        @users = User.all

        render json: @users
      end

      # GET /users/1
      def show
        render json: @user
      end

      # POST /users
      def create
        @user = User.new(signup_user_params)

        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /users/1
      def update
        if @user.update(user_params)
          render json: @user
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
    end
  end
end
