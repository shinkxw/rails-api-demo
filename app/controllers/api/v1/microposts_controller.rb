module Api
  module V1
    class MicropostsController < ApplicationController
      before_action :set_micropost, only: [:show, :update, :destroy]
      before_action :authenticate_jwt, only: [:create, :destroy]
      before_action :correct_user, only: :destroy

      # GET /microposts
      def index
        query = Micropost.includes(:user)
        query = query.where(user_id: params[:user_id]) if params[:user_id]
        model = paginate(query)[:data].first
        render :json => paginate(query).to_json(:include => { :user => { :only => [:name, :email] } } )
      end

      # GET /microposts/1
      def show
        render json: @micropost
      end

      # POST /microposts
      def create
        @micropost = current_user.microposts.build(micropost_params)

        if @micropost.save
          render json: @micropost, status: :created
        else
          render json: @micropost.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /microposts/1
      # def update
      #   if @micropost.update(micropost_params)
      #     render json: @micropost
      #   else
      #     render json: @micropost.errors, status: :unprocessable_entity
      #   end
      # end

      # DELETE /microposts/1
      def destroy
        @micropost.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_micropost
          @micropost = Micropost.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def micropost_params
          params.require(:micropost).permit(:content)
        end

        def correct_user
          @micropost = current_user.microposts.find_by(id: params[:id])
          return unauthorize_error if @micropost.nil?
        end
    end
  end
end
