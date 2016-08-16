module Api
  module V1
    class RelationshipsController < ApplicationController
      before_action :authenticate_jwt, only: [:create, :destroy]

      # POST /relationships
      def create
        user = User.find(params[:followed_id])
        current_user.follow(user)
      end

      # DELETE /relationships/1
      def destroy
        user = Relationship.find(params[:id]).followed
        current_user.unfollow(user)
      end

    end
  end
end
