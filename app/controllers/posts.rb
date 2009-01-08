class Posts < Application
  # provides :xml, :yaml, :js

  before :ensure_authenticated, :exclude => [:index, :show, :comment, :list_by_category, :show_by_old_permalink]
  
  # GET /posts
  def index
	provides :rss
	page= params[:page] || "1"
    @posts = Post.reverse_order(:created_at).paginate(page.to_i, 4)
    display @posts
  end

  def list_by_category(name)
	page= params[:page] || "1"
	c= Category[:name => name]
    raise NotFound unless c
    pids = c.posts.collect{ |i| i.id}
    @posts = Post.filter(:id => pids).reverse_order(:created_at).paginate(page.to_i, 4)
    display @posts, :index
  end

  def list_by_tag(name)
	page= params[:page] || "1"
	c= Tag[:name => name]
    raise NotFound unless c
    pids = c.posts.collect{ |i| i.id}
    @posts = Post.filter(:id => pids).reverse_order(:created_at).paginate(page.to_i, 4)
    display @posts, :index
  end

  # GET /posts/:id
  def show
    @post = Post[params[:id]]
    raise NotFound unless @post
    display @post
  end

  def show_by_old_permalink(year, month, day, title)
	@post= Post.find_by_permalink(title)
    raise NotFound unless @post
    display @post, :show
  end

  # GET /posts/new
  def new
    only_provides :html
    @post = Post.new
    render
  end

  # POST /posts
  def create
    @post = Post.new(params[:post])
	begin
	  @post.save
      redirect url(:post, @post)
    rescue
      render :new
    end
  end

  # GET /posts/:id/edit
  def edit
    only_provides :html
    @post = Post[params[:id]]
    raise NotFound unless @post
    render
  end

  # PUT /posts/:id
  def update
    @post = Post[params[:id]]
    raise NotFound unless @post
	begin
      @post.update(params[:post])
      redirect url(:post, @post)
    rescue
      render :edit
    end
  end

  # DELETE /posts/:id
  # TODO need to delete comments first
  def destroy(id)
    @post = Post[id]
    raise NotFound unless @post
	begin
	  Comment.delete_comments_for_post(@post.id)
      @post.destroy
      redirect url(:posts, :message => {:notice =>"Post deleted"})
	rescue
      raise NotFound
    end
  end

  # POST /posts/comment
  # adds a comment to the given post
  def comment
	@post= Post[params[:postid]]
    raise NotFound unless @post

    @comment = Comment.new(params[:comment])
	begin
	  @post.add_comment(@comment)
	  redirect url(:post, @post, {:fragment => 'comments', :message => {:notice =>"Comment deleted"}})
	rescue
	  #err= @comment.errors.full_messages
	  redirect url(:post, @post, {:fragment => 'respond', :message => {:notice =>"try again"}})
	end
  end

  def delete_comment
	id= params[:commentid]
	comment= Comment[id]
	post= comment.post
	comment.destroy
    redirect url(:post, post)
  end

  def comments_feed
	provides :rss
	@comments= Comment.reverse_order(:created_at).limit(10)
    display @comments
  end
end
