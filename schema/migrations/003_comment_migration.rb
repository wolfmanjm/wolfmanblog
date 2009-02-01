# For details on Sequel migrations see
# http://sequel.rubyforge.org/
# http://code.google.com/p/ruby-sequel/wiki/Migrations

class CommentMigration < Sequel::Migration

  def up
    create_table :comments do
      primary_key :id
      text :name
      text :body, :null => false
      text :email
      text :url
      text :guid
      foreign_key :post_id, :posts, :null => false
      timestamp :created_at, :null => false
      timestamp :updated_at, :null => false
    end
  end

  def down
    drop_table :comments
  end

end
