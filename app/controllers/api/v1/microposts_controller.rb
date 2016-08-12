module Api
  module V1
    class MicropostsController < ApplicationController
      before_action :set_micropost, only: [:show, :update, :destroy]

      # GET /microposts
      def index
        query = Micropost.all
        query = query.where(user_id: params[:user_id]) if params[:user_id]

        page = params[:page] ? params[:page].to_i : 1
        page_size = params[:page_size] ? params[:page_size].to_i : 30

        @users = query.limit(page_size).offset(page_size * (page - 1))

        render json: { data: @users, all_count: query.count }
      end

      # GET /microposts/1
      def show
        render json: @micropost
      end

      # POST /microposts
      def create
        @micropost = Micropost.new(micropost_params)

        if @micropost.save
          render json: @micropost, status: :created
        else
          render json: @micropost.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /microposts/1
      def update
        if @micropost.update(micropost_params)
          render json: @micropost
        else
          render json: @micropost.errors, status: :unprocessable_entity
        end
      end

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
          params.require(:micropost).permit(:content, :user_id)
        end
    end
  end
end
