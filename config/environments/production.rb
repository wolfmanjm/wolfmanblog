Merb.logger.info("Loaded PRODUCTION Environment...")
Merb::Config.use { |c|
  c[:exception_details] = false
  c[:reload_classes] = false
  c[:log_level] = :error

  c[:log_file]  = Merb.root / "log" / "production.log"
  # or redirect logger using IO handle
  # c[:log_stream] = STDOUT
}

Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
  Merb::Cache.setup do
    register(:page_store, Merb::Cache::PageStore[Merb::Cache::FileStore], :dir => Merb.root / 'public' / 'cache')
    register(:action_store, Merb::Cache::ActionStore[Merb::Cache::FileStore], :dir => Merb.root / 'tmp' / 'cache')
    #register(:default, Merb::Cache::AdhocStore.new)
    register(:default, Merb::Cache::AdhocStore[:action_store])
  end

  # add delete_all to Merb::Cache::Filestore
  Merb::Cache::FileStore.class_eval do
    def delete_all!
      #puts "FileStore#delete_all! - rm -rf #{Dir.glob( @dir / '*').inspect}"
      FileUtils.rm_rf(Dir.glob( @dir / '*'))
    end
  end
end
