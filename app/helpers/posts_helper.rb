module Merb
  module PostsHelper
	def num_comments(post)
	  n= post.comments.size
	  if n > 0
		link_to "#{n.to_s} comments", url(:post, post)
	  else
		"no comments"
	  end
	end
  end
end # Merb