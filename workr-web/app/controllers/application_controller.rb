class ApplicationController < ActionController::Base
  def store_location
    # - store last url as long as it isn't a /users path
    @@return_location = request.fullpath unless request.fullpath =~ /\/users/
  end

  def after_sign_in_path_for(resource)
    if defined?(@@return_location) && !@@return_location.blank? && request.referrer =~ /\/users/
      location = @@return_location
      @@return_location = nil
      return location
    else
      @@return_location = nil
      return root_path
    end
  end
end
