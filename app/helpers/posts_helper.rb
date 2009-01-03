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

	# TODO make these links
	def categories(post)
	  l= []
	  a= post.categories
	  a.each do |i|
		l << i.name
	  end
	  l.join(',')
	end

	# TODO make these links
	def tags(post)
	  l= []
	  a= post.tags
	  a.each do |i|
		l << i.name
	  end
	  l.join(',')
	end
  end
end # Merb