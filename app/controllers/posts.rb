class Posts < Application
  # provides :xml, :yaml, :js

  before :ensure_authenticated, :exclude => [:index, :show, :list_by_category, :list_by_tag, :show_by_old_permalink]
  
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
	provides :rss
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
    @post= Post.new
	@post.title= params[:post][:title]
	@post.body= params[:post][:body]
	begin
	  @post.save
	  @post.update_categories_and_tags(params[:post][:categories_csv], params[:post][:tags_csv])
      redirect url(:post, @post)
    rescue
      render :new
    end
  end

  # POST /posts/upload
  # upload a post, check if it is new or existing and update or create accordingly
  def upload
	begin
	  @h= parse_upload(request.raw_post)
	rescue
	  Merb::logger.error("Failed to parse YAML: #{$!}")
	  raise PreconditionFailed
	end

	@post= Post.find(:title => @h[:title])
	if @post.nil?
	  @post= Post.new
	  @post.title= @h[:title]
	end

	@post.body= @h[:body]
	begin
	  @post.save
	  @post.update_categories_and_tags(@h[:categories].join(','), @h[:tags].split(' ').join(','))
	rescue
	  Merb::logger.error("Failed to save upload: #{$!} - #{@post.errors.full_messages}")
	  raise PreconditionFailed
	end
    redirect url(:post, @post)
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
      @post.update(:title => params[:post][:title], :body => params[:post][:body])
	  @post.update_categories_and_tags(params[:post][:categories_csv], params[:post][:tags_csv])
      redirect url(:post, @post)
    rescue
      render :edit
    end
  end

  # DELETE /posts/:id
  def destroy(id)
    @post = Post[id]
    raise NotFound unless @post
	begin
	  Comment.delete_comments_for_post(@post.id)
	  @post.remove_all_tags
	  @post.remove_all_categories
      @post.destroy
      redirect url(:posts, :message => {:notice =>"Post deleted"})
	rescue
      raise NotFound
    end
  end

  private

  def parse_upload(data)
	# read documents, there are two, the first has the params, the second is the actual post
	params, body = YAML.load_stream(data).documents

	puts "params: #{params.inspect}"
	puts "body: #{body.inspect}"
	
	if params.nil? || params.empty? || body.nil? || body.empty?
	  raise "input format is bad"
	end

	if !params.has_key?('title')
	  raise "Must have a title"
	end

	if !params.has_key?('categories')
	  raise "Must have categories"
	end

	{ :title => params['title'], :categories => params['categories'],
	  :tags => params['keywords'], :body => body}

  end
end
