# For details on Sequel migrations see
# http://sequel.rubyforge.org/
# http://code.google.com/p/ruby-sequel/wiki/Migrations

class PostMigration < Sequel::Migration

  def up
    create_table :posts do
      primary_key :id
      text :body
      text :title
	  text :author
	  boolean :allow_comments, :default => true
	  boolean :comments_closed, :default => false
	  timestamp :created_at, :null => false
	  timestamp :updated_at, :null => false
    end
  end

  def down
    drop_table :posts
  end

end
