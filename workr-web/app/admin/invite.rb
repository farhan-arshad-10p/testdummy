ActiveAdmin.register Invite do
  controller do
    def permitted_params
      params.permit invite: [:code, :active, :user_id]
    end
  end
end
