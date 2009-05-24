class Posts < Application
  # provides :xml, :yaml, :js

  before :ensure_authenticated, :exclude => [:index, :show, :list_by_category, :list_by_tag, :show_by_id]
  after :flush_cache, :only => [:create, :upload, :destroy]
  
  cache [:index, :show, :list_by_category, :list_by_tag], { :unless => :authenticated }
  
  # GET /posts
  def index(page = "1")
    provides :rss
    page ||= "1"
    @posts = Post.reverse_order(:created_at).paginate(page.to_i, 4)
    display @posts
  end

  def list_by_category(name, page = "1")
    page ||= "1"
    c= Category[:name => name]
    raise NotFound unless c
    pids = c.posts.collect{ |i| i.id}
    @posts = Post.filter(:id => pids).reverse_order(:created_at).paginate(page.to_i, 4)
    display @posts, :index
  end

  def list_by_tag(name, page = "1")
    page ||= "1"
    c= Tag[:name => name]
    raise NotFound unless c
    pids = c.posts.collect{ |i| i.id}
    @posts = Post.filter(:id => pids).reverse_order(:created_at).paginate(page.to_i, 4)
    display @posts, :index
  end

  # GET /posts/:id
  def show_by_id(id)
    # this protects against spambots sending in 101#blahblah
    raise NotFound unless id =~ /^\d+$/
    @post = Post[id]
    raise NotFound unless @post
    redirect permalink(@post)
  end

  # GET /articles/:year/:month/:day/:permalink
  def show(year, month, day, title)
    provides :rss
    @post= Post.find_by_permalink(title)
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
    @post= Post.new
    @post.title= params[:post][:title]
    @post.body= params[:post][:body]
    begin
      @post.save
      @post.update_categories_and_tags(params[:post][:categories_csv], params[:post][:tags_csv])
      redirect permalink(@post)
    rescue
      @_message= {:error => "Create failed"}
      render :new
    end
  end

  # POST /posts/upload upload a post, check if it is new or existing and update or create accordingly
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
    redirect url(:post, @post), :message => {:notice => 'Upload OK'}
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
      redirect url(:posts), :message => {:notice => "Post deleted"}
    rescue
      raise NotFound
    end
  end

  private

  def parse_upload(data)
    # read documents, there are two, the first has the params, the second is the actual post
    params, body = YAML.load_stream(data).documents

#    puts "params: #{params.inspect}"
#    puts "body: #{body.inspect}"
	
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

  # flushes the entire page store cache
  def flush_cache
    Merb::Cache[:action_store].delete_all!    
  end

  def authenticated
    session.authenticated?
  end
end
