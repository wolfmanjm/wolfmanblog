class Tag < Sequel::Model
  many_to_many :posts

  def self.find_all_with_article_counters(limit = 20)
    db.fetch(%{
      SELECT tags.id, tags.name, COUNT(posts_tags.post_id) AS article_counter
      FROM tags LEFT OUTER JOIN posts_tags
      ON posts_tags.tag_id = tags.id
      LEFT OUTER JOIN posts
      ON posts_tags.post_id = posts.id
      GROUP BY tags.id, tags.name
      ORDER BY article_counter DESC
      LIMIT #{limit} }
    ).all
  end

end
