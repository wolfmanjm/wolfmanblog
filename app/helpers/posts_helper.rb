module Merb
  module PostsHelper
	def num_comments(post)
	  n= post.comments_size
	  if n > 0
		link_to "#{n.to_s} comments", url(:post, post, :fragment => 'comments')
	  else
		"no comments"
	  end
	end

	def categories(post)
	  l= []
	  a= post.categories
	  a.each do |i|
		l << link_to(i.name, url(:category, i.name))
	  end
	  l.join(',')
	end

	def tags(post)
	  l= []
	  a= post.tags
	  a.each do |i|
		l << link_to(i.name, url(:tag, i.name))
	  end
	  l.join(',')
	end

  end
end # Merb