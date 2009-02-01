# For details on Sequel migrations see 
# http://sequel.rubyforge.org/
# http://code.google.com/p/ruby-sequel/wiki/Migrations

class CreateTagsMigration < Sequel::Migration

  def up
    create_table :tags do
      primary_key :id
      text :name, :unique => true
    end

    create_table :categories do
      primary_key :id
      text :name, :unique => true
    end

    create_table :categories_posts do
      primary_key :id
      foreign_key :post_id, :posts, :null => false
      foreign_key :category_id, :categories, :null => false
    end

    create_table :posts_tags do
      primary_key :id
      foreign_key :post_id, :posts, :null => false
      foreign_key :tag_id, :tags, :null => false
    end
  end

  def down
    drop_table :posts_tags
    drop_table :categories_posts
    drop_table :categories
    drop_table :tags
  end

end
