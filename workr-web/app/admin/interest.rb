ActiveAdmin.register Interest do
  controller do
    def permitted_params
      params.permit interest: [:name]
    end
  end
end
