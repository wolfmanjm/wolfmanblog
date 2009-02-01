# For details on Sequel migrations see
# http://sequel.rubyforge.org/
# http://code.google.com/p/ruby-sequel/wiki/Migrations

class UserMigration < Sequel::Migration

  def up
    create_table :users do
      primary_key :id
      text :name
      text :crypted_password
      text :salt
      boolean :admin
    end
  end

  def down
    drop_table :users
  end

end
