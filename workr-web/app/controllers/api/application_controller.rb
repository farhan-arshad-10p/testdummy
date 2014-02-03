module Api
  class ApplicationController < ActionController::API
    before_filter :authenticate_user!
  end
end

