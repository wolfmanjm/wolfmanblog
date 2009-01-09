# TODO create guid on creation
class Comment < Sequel::Model
  is :timestamped
  belongs_to :post

  validates do
	presence_of :body
  end

  def self.delete_comments_for_post(id)
	filter(:post_id => id).delete
  end
end
