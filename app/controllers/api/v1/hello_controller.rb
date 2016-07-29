module Api
  module V1
    class HelloController < ApplicationController

      def hello
        # optional! :limit, values: 0..100

        render json: 'hello'
      end
    end
  end
end
