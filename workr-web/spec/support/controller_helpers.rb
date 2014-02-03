module ControllerHelpers
  def login_user(user, options={})
    sign_in user 
    controller.stub(:current_user) { user }
    controller.stub(:authorize_user) {raise 'Unathorized for this test' if options[:authorized] == false}
  end
end

RSpec.configure { |c| c.include(ControllerHelpers, type: :controller) }
