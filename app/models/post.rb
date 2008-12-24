class Post < Sequel::Model
  is :timestamped
  has_many :comments

  def to_html
	doc= Maruku.new(body)
	doc.to_html
  end

end
