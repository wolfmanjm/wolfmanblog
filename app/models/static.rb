class Static < Sequel::Model
  validates do
    presence_of :title, :body
  end
end
