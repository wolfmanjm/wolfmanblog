class Comments < Application

  before :ensure_authenticated, :exclude => [:index, :create]

  # POST /comments
  # adds a comment to the given post
  def create
	unless params[:test] =~ /no/i
	  Merb.logger.error "spam comment: #{params.inspect}"
	  raise NotHuman
	end
	
	@post= Post[params[:postid]]
    raise NotFound unless @post

    @comment = Comment.new(params[:comment])
	begin
	  @post.add_comment(@comment)
	  redirect url(:post, @post, {:fragment => 'comments'})
	rescue
	  #err= @comment.errors.full_messages
	  redirect url(:post, @post, {:fragment => 'respond', :message => {:notice =>"try again"}})
	end
  end

  def delete
	id= params[:commentid]
	comment= Comment[id]
	post= comment.post
	comment.destroy
    redirect url(:post, post)
  end

  def index
	provides :rss
	@comments= Comment.reverse_order(:created_at).limit(10).eager(:post).all
    display @comments
  end

end