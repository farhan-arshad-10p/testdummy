ActiveAdmin.register User do
  index do
    column :email
    column :last_name
    column :first_name
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  show do |user|
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :interests do
        user.interests.map(&:name).join(', ')
      end
      row :current_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_at
      row :last_sign_in_ip
      row :sign_in_count
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :interests, as: :check_boxes
      f.input :terms_of_service
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit user: [:email, :first_name, :last_name, :password, :password_confirmation, :terms_of_service, {:interest_ids => []} ]
    end
  end
end
