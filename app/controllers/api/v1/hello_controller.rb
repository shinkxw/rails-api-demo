module Api
  module V1
    class HelloController < ApiController

      def hello
        # optional! :limit, values: 0..100

        render json: 'hello'
      end
    end
  end
end
