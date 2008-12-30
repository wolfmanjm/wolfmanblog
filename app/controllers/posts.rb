class Posts < Application
  # provides :xml, :yaml, :js
  before :ensure_authenticated, :exclude => [:index, :show, :comment]
  
  # GET /posts
  def index
	page= params[:page] || "1"
    @posts = Post.reverse_order(:created_at).paginate(page.to_i, 4)
    display @posts
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
    if @post.save
      redirect url(:post, @post)
    else
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
    if @post.update(params[:post])
      redirect url(:post, @post)
    else
      raise BadRequest
    end
  end

  # DELETE /posts/:id
  def destroy(id)
    @post = Post[id]
    raise NotFound unless @post
    if @post.destroy
      redirect url(:posts)
    else
      raise BadRequest
    end
  end

  # POST /posts/comment
  # adds a comment to the given post
  def comment
	@post= Post[params[:postid]]
    raise NotFound unless @post

    comment = Comment.new(params[:comment])
	@post.add_comment(comment)
    redirect url(:post, @post)
  end

  def delete_comment
	id= params[:commentid]
	comment= Comment[id]
	post= comment.post
	comment.destroy
    redirect url(:post, post)
  end
end
