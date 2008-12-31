class Comment < Sequel::Model
  is :timestamped
  belongs_to :post

  validates do
	presence_of :body
  end

end
