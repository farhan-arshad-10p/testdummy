module Api
  module V1
    class FlagsController < Api::ApplicationController
      def create
        params = flag_params()
        params[:article_id] = params.delete(:article)

        current_user.flags.create!(params)

        render nothing: true, status: :ok
      end

      private
       def flag_params
         params.require(:flag).permit(:article, :reason)
       end
    end
  end
end
