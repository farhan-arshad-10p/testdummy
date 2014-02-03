ActiveAdmin.register ActsAsTaggableOn::Tag, as: 'Tags' do
  controller do
    def permitted_params
      params.permit tags: [:name]
    end
  end
end
