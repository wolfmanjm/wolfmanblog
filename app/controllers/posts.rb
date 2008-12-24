class Posts < Application
  # provides :xml, :yaml, :js

  # GET /posts
  def index
    @posts = Post.all
    display @posts
  end

  # GET /posts/:id
  def show
    @post = Post[params[:id]]
    raise NotFound unless @post
    display @post
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
  def delete(id)
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
  # TODO could be done better with routing
  def comment
	@post= Post[params[:postid]]
    raise NotFound unless @post

    comment = Comment.new(params[:comment])
	@post.add_comment(comment)
    redirect url(:post, @post)
  end

end
