class Statics < Application
  before :ensure_authenticated

  def index
    @statics= Static.all
    render
  end

  # GET /statics/:id
  def show
    @static = Static[params[:id]]
    raise NotFound unless @static
    display @static
  end


  # GET /statics/new
  def new
    only_provides :html
    @static= Static.new
    render
  end

  # POST /statics
  def create
    @static= Static.new(params[:static])
    begin
      @static.save
      redirect url(:static, @static)
    rescue
      @_message= {:error => "Create failed"}
      render :new
    end
  end

  # GET /statics/:id/edit
  def edit
    only_provides :html
    @static = Static[params[:id]]
    raise NotFound unless @static
    render
  end

  # PUT /statics/:id
  def update
    @static = Static[params[:id]]
    raise NotFound unless @static

    begin
      @static.update(params[:static])
      redirect url(:static, @static)
    rescue
      render :edit
    end
  end

  # DELETE /statics/:id
  def destroy(id)
    @static = Static[id]
    raise NotFound unless @static
    begin
      @static.destroy
      redirect url(:statics), :message => {:notice => "static deleted"}
    rescue
      raise NotFound
    end
  end

end
