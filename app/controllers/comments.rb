class Comments < Application

  before :ensure_authenticated, :exclude => [:index, :create]

  # POST /comments adds a comment to the given post
  def create
    unless params[:test] =~ /^no$/i
      #Merb.logger.error "spam comment: #{params.inspect}"
      raise NotHuman
    end

    @post= Post[params[:postid]]
    raise NotFound unless @post

    @comment = Comment.new(params[:comment])
    begin
      @post.add_comment(@comment)
      flush_cache
      redirect permalink(@post, {:fragment => 'comments'})
    rescue
      # #err= @comment.errors.full_messages
      redirect(permalink(@post), :message => {:error => "Failed to post comment"})
    end
  end

  def destroy
    id= params[:commentid]
    comment= Comment[id]
    post= comment.post
    comment.destroy
    flush_cache
    redirect(permalink(post, :fragment => 'comments'), :message => {:notice => 'comment deleted'})
  end

  def index
    provides :rss
    @comments= Comment.reverse_order(:created_at).limit(10).eager(:post).all
    display @comments
  end

  private

  def flush_cache
    return if Merb.environment != 'production'

    # TODO try to flush just the affected article
    Merb::Cache[:action_store].delete_all!
  end
end
