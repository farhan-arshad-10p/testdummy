ActiveAdmin.register Collection do
  controller do
    def permitted_params
      params.permit collection: [:name, :description, :user_id]
    end
  end
end
