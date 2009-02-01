class Category < Sequel::Model
  many_to_many :posts

  def count
    posts.size
  end
end
