#
# Direct database manipulation, used for setting up database for tests
#
Given 'The database table $table is truncated' do |t|
  @db.execute("TRUNCATE #{t} CASCADE")
end

# eventually we can do it this way
#Given 'The database contains:' do |data|
#  data.hashes.each do |h|
#    table= h['table']
#    col= h['column']
#    val= h['value']
#    puts "Setting database table #{table} column #{col} to #{val}"
#  end

Given 'user $name with $password and $salt' do |n, p, s|
  @db[:users] << {:name => n, :crypted_password => p, :salt => s}
end
