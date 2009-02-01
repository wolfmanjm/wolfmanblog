class Comment < Sequel::Model
  is :timestamped
  belongs_to :post

  validates do
    presence_of :body
  end

  before_create do
    self.guid= UUID.random_create
  end

  def self.delete_comments_for_post(id)
    filter(:post_id => id).delete
  end
end
