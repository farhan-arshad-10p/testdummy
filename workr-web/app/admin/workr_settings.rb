ActiveAdmin.register WorkrSettings do
  actions :index, :show, :edit, :update

  controller do
    def permitted_params
      params.permit workr_settings: [:article_search_settings]
    end
  end
end
