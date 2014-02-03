ActiveAdmin.register HostedFile do
  form(:html => { :multipart => true }) do |f|
    f.inputs "Hosted File" do
      f.input :upload, as: :file
    end
    f.actions
  end

  index do
    column :id
    column :upload_file_name
    column :upload_content_type
    column :upload_updated_at
    default_actions
  end

  show do |hosted_file|
    attributes_table do
      row :id
      row :upload_file_name
      row :upload_file_url do
        hosted_file.upload.url
      end
      row :upload_content_type
      row :upload_updated_at
    end
    active_admin_comments
  end

  action_item :only => :show do
    link_to('Clip file to new article', clip_admin_articles_path(clip: {url: hosted_file.upload.url}))
  end

  controller do
    def permitted_params
      params.permit hosted_file: :upload
    end
  end
end
