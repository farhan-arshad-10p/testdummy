ActiveAdmin.register ContentSource do
  actions :index, :show, :clip

  action_item do
    link_to "Clip new article", clip_admin_articles_path
  end

  show do |url|
    attributes_table do
      row :url
      row :content
      row :raw_article
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
