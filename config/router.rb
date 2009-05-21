# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   match("/books/:book_id/:action").
#     to(:controller => "books")
#
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can specify conditions on the placeholder by passing a hash as the second
# argument of "match"
#
#   match("/registration/:course_name", :course_name => /^[a-z]{3,5}-\d{5}$/).
#     to(:controller => "registration")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
 
  # make pagination a url for caching, p must be 'page'
  match("/posts(/:p/:page)", :page => /^\d+$/, :method => :get).to(:controller => 'posts', :action =>'index')

  # route by post id, redirected to route by permalink in controller
  match("/posts/:id", :method => :get).to(:controller => 'posts', :action =>'show_by_id').name(:post)

  # route by permalink
  match("/articles/:year/:month/:day/:title").to(:controller => "posts", :action => "show").name(:article)

  # RESTful routes
  resources :posts
  resources :statics


  match("/posts/upload", :method => :post).to(:controller => "posts", :action => "upload").name(:upload_post)

  # Adds the required routes for merb-auth using the password slice
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  match("/comments/:commentid", :method => :delete).to(:controller => "comments", :action => "destroy").name(:delete_comment)
  match("/comments/:postid", :method => :post).to(:controller => "comments", :action => "create").name(:add_comment)
  match("/comments(\.:format)").to(:controller => "comments", :action => "index").name(:comments)

  match("/articles/category/:name(/:p/:page)").to(:controller => "posts", :action => "list_by_category").name(:category)
  match("/articles/tag/:name(/:p/:page)").to(:controller => "posts", :action => "list_by_tag").name(:tag)

 
 
  # route old rss feeds
  match("/xml/rss20/comments/feed.xml").to(:controller => "comments", :action => "index", :format => :rss)
  match("/xml/rss20/feed.xml").to(:controller => "posts", :action => "index", :format => :rss)
  match("/xml/rss20/article/:id/feed.xml").to(:controller => "posts", :action => "show", :format => :rss)

  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET
  #default_routes

  # Change this for your home page to be available at /
  match('/').defer_to do
    redirect "/posts/page/1"
  end
  
end
