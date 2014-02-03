ActiveAdmin.register Article do
  actions :index, :show, :edit, :update, :destroy, :clip, :create_clip

  action_item do
    link_to "Clip new article", clip_admin_articles_path
  end

  index do
    selectable_column
    column :title
    column :user
    default_actions
  end

  show do |article|
    attributes_table do
      row :user
      row :title
      row :featured_image do
        article.content_source.featured_image_url
      end
      row :description
      row :content do
        article.content_source.content
      end
      row :tags do
        article.tag_list
      end
      row :url do
        article.content_source.url
      end
      row :collections do
        article.collections.map(&:name).join(', ')
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Article Details" do
      f.input :title
      f.input :description
      f.input :user
      f.input :collections do
        user.collections
      end
    end
    f.actions
  end

  collection_action :clip, method: :get do
    @clip = params["clip"]
    @clip ||= {
      url: nil,
      title: nil,
      description: nil,
      collection: nil,
      tags: nil,
    }
    @clip = OpenStruct.new(@clip)
    @article = OpenStruct.new(errors: [])
  end

  collection_action :create_clip, method: :post do
    @clip = params["clip"]
    @clip ||= {
      url: nil,
      title: nil,
      description: nil,
      collection: nil,
      tags: nil,
    }

    @clip = OpenStruct.new(@clip)
    collection = Collection.find(@clip.collection)
    article_args =  {
      collection_ids: [collection.id],
      user_id: collection.user_id,
      title: @clip.title,
      description: @clip.description,
      tag_list: @clip.tags
    }

    content_source = Clipper::Importer.import_content_source(url: @clip.url)
    @article = ArticleManager.create_from_content_source(content_source, article_args)

    if @article.valid?
      redirect_to admin_article_path(@article)
    else
      render active_admin_template('clip.html')
    end
  end

  controller do
    def permitted_params
      params.permit article: [:url, :description, :title, :content, :tag_list]
    end
    def scoped_collection
      Article.includes(:user, :content_source)
    end
  end
end
