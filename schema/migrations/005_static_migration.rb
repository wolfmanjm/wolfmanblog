# For details on Sequel migrations see
# http://sequel.rubyforge.org/
# http://sequel.rubyforge.org/rdoc/classes/Sequel/Database.html#M000607

class StaticMigration < Sequel::Migration

  def up
    create_table :statics do
      primary_key :id
      text :title, :null => false
      text :body, :null => false
      integer :position, :default => 0
    end
  end

  def down
    drop_table :statics
  end

end
