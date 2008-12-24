class Comment < Sequel::Model
  is :timestamped
  belongs_to :post
end
