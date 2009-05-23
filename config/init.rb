# Go to http://wiki.merbivore.com/pages/init-rb

require 'config/dependencies.rb'

use_orm :sequel
use_test :rspec
use_template_engine :haml

Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper

  # cookie session store configuration
  c[:session_secret_key]  = '425f5f068e60f59da44160a608c42b396e0c218c'  # required for cookie session store
  c[:session_id_key] = '_wolfmanblog_session_id' # cookie session id key, defaults to "_session_id"
end

Merb.add_mime_type :rss, nil, %w[text/xml]

# Make the app's "lib" directory a place where ruby files get "require"d from
$LOAD_PATH.unshift(Merb.root / "lib")

Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
  # require everything in lib
  Dir[Merb.root / 'lib' / '*.rb'].each do |ext|
    require(ext)
  end
end

Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
  Merb::Cache.setup do
    register(:page_store, Merb::Cache::PageStore[Merb::Cache::FileStore], :dir => Merb.root / "public/cache")
    #register(:action_store, Merb::Cache::ActionStore[Merb::Cache::FileStore], :dir => Merb.root / "tmp")
    register(:default, Merb::Cache::AdhocStore[:page_store]) # , :action_store])
  end

  # add delete_all to Merb::Cache::Filestore
  Merb::Cache::FileStore.class_eval do
    def delete_all!
      #puts "FileStore#delete_all! - rm -rf #{Dir.glob( @dir / '*').inspect}"
      FileUtils.rm_rf(Dir.glob( @dir / '*'))
    end
  end


  require 'will_paginate/view_helpers/link_renderer'

  # patch to use special page
  WillPaginate::ViewHelpers::LinkRenderer.class_eval do
    protected

    def url(page)
      params = @template.request.params.except(:action, :controller).merge(:p => 'page', 'page' => page)
      @template.url(:this, params)
    end
  end
  
end

#$DEBUG= true
