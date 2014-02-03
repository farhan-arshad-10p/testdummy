class Repository
  def initialize(world)
    @my = world.my
    @their = world.their
    @world = world
  end

  def invite(args={})
    ctx = context(args)
    Fabricate(:invite, args)
  end

  def user(args={})
    ctx = context(args)
    Fabricate(:user, args)
  end

  def admin_user(args={})
    ctx = context(args)
    Fabricate(:admin_user, args)
  end

  def content_source(args={})
    ctx = context(args)
    Fabricate(:content_source, args)
  end

  def article(args={})
    ctx = context(args)
    args[:content_source_id] ||= ctx.content_source.id
    args[:user_id] ||= ctx.user.id
    article = Fabricate(:article, args)
    ArticleManager.add_article_to_collection!(article, ctx.collection.id)
    article
  end

  def collection(args={})
    ctx = context(args)
    args[:user_id] ||= ctx.user.id
    Fabricate(:collection, args)
  end

  def category(args={})
    ctx = context(args)
    Fabricate(:category, args)
  end

  def interest(args={})
    ctx = context(args)
    Fabricate(:interest, args)
  end


private
# +++++++++++++++++++++++++++ I DELETE STUFF!!!!!!!!!!!! ++++++++++++
# +++++++++++++++++++++++++++ I DELETE STUFF!!!!!!!!!!!! ++++++++++++
# +++++++++++++++++++++++++++ I DELETE STUFF!!!!!!!!!!!! ++++++++++++
# +++++++++++++++++++++++++++ I DELETE STUFF!!!!!!!!!!!! ++++++++++++
  def context(args)
    context = args.delete(:context)
    context || @my
  end
end

class My
  attr_writer :invite, :interest, :user, :article, :articles, :collection, :content_source

  def invite
    raise "invite not set" unless @invite
    return @invite
  end

  def content_source
    raise "content_source not set" unless @content_source
    @content_source
  end

  def interest
    raise "interest not set" unless @interest
    return @interest
  end

  def user
    raise "user not set" unless @user
    return @user
  end

  def collection
    raise "collection not set" unless @collection
    return @collection
  end

  def collection_set?
    @collection.present?
  end

  def collections
    @collections ||= []
  end

  def users
    @users ||= []
  end

  def article
    raise "article not set" unless @article
    return @article
  end

  def articles
    @articles ||= []
  end

  def embedly_responses
    @embedly_responses ||= []
  end

  def interests
    @interests ||= []
  end
end
