#
# Helper class to manipulate database directly
#
class DBHelper
  Tables = [:posts, :comments, :tags, :categories, :categories_posts, :posts_tags, :users, :statics]
  
  attr_reader :db
  # setup database access
  def initialize(target=nil, debug=nil)
    if target.nil?
      @@target= ENV['testtarget'].nil? ? "test" : ENV['testtarget']
    else
      @@target= target
    end
    dburl= case @@target
      when 'test'
        "postgres://morris:test@localhost:5432/sample1_test"
      else
        raise 'Bad target'
    end

    @db= Sequel.open dburl
    dblog= Logger.new($stdout)
    dblog.level= debug ? Logger::INFO : Logger::WARN
    @db.logger= dblog
  end

  def close
    @db.disconnect
  end

  def clean
    tables= Tables.collect {|t| t.to_s}
    @db.execute("TRUNCATE #{tables.join(',')} CASCADE")
    @db.execute("ALTER SEQUENCE posts_id_seq RESTART WITH 1")
  end
  
  def truncate(*table)
    tables= table.collect {|t| t.to_s}
    @db.execute("TRUNCATE #{tables.join(',')} CASCADE")
  end

  def add_user(name, password, salt)
    @db[:users] << {:name => name, :crypted_password => password, :salt => salt}
  end

  def add_post(h)
    @db[:posts].insert(h.merge(:created_at => Time.now.iso8601, :updated_at => Time.now.iso8601, :guid => "guid:#{rand(1000000)}"))
  end

  def add_comment(postid, comment, by)
    @db[:comments].insert(:post_id => postid, :body => comment, :name => by, :created_at => Time.now.iso8601, :updated_at => Time.now.iso8601)
  end

  def tag_post(postid, tag)
    r= @db[:tags].filter(:name => tag).first
    id= r.nil? ? @db[:tags].insert(:name => tag) : r[:id]
    @db[:posts_tags] << {:post_id => postid, :tag_id => id}
  end

  def categorize_post(postid, cat)
    r= @db[:categories].filter(:name => cat).first
    id= r.nil? ? @db[:categories].insert(:name => cat) : r[:id]
    @db[:categories_posts] << {:post_id => postid, :category_id => id}
  end
end
