#
# Helper class to manipulate database directly
#
class DBHelper
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
  
  def truncate(table)
    @db.execute("TRUNCATE #{table.to_s} CASCADE")
  end

  def add_user(name, password, salt)
    @db[:users] << {:name => name, :crypted_password => password, :salt => salt}
  end

  def add_post(h)
    @db[:posts].insert(h.merge(:created_at => Time.now.iso8601, :updated_at => Time.now.iso8601))
  end
end