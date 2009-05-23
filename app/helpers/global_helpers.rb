module Merb
  module GlobalHelpers
    # helpers defined here available to all views.
    def sidebar(name)
      part SidebarPart => name
    end

    def permalink(post, opts={})
      url(:article, post.year, post.month, post.day, post.permalink, opts)
    end

    def absolute_permalink(post)
      absolute_url(:article, post.year, post.month, post.day, post.permalink)
    end

  end
end
