class SidebarPart < Merb::PartController

  def index
    # define sidebars in the display order
    @sidebars=  [sb_google_search, sb_contact, sb_links, sb_syndicate, sb_categories, sb_tags, sb_recent_comments, sb_index, sb_ads]
    display @sidebars
  end

   def syndicate
     render
   end

   def google_search
     render
   end

   def contact
     render
   end

   def links
     render
   end

   def categories
     @categories= Category.eager(:posts).all
     render
   end

   # build tag cloud (taken from typo)
   def tags
     tags= Tag.find_all_with_article_counters(20)
     total= tags.inject(0) {|total,tag| total += tag[:article_counter] }
     average = total.to_f / tags.size.to_f
     sizes = tags.inject({}) {|h,tag| h[tag[:name]] = (tag[:article_counter].to_f / average); h} # create a percentage
     # apply a lower limit of 50% and an upper limit of 200%
     sizes.each {|tag,size| sizes[tag] = [[2.0/3.0, size].max, 2].min * 100}

     str= "<p style=\"overflow:hidden\">"
     tags.sort{|x,y| x[:name] <=> y[:name]}.each do |tag|
       str += "<span style=\"font-size:#{sizes[tag[:name]]}%\"> #{link_to(tag[:name], url(:tag, tag[:name]))}</span>"
     end
     str += "</p>"
     @body= str
     render
   end

   def recent_comments
     @comments= Comment.limit(10).order(:created_at.desc).eager(:post).all
     render
   end

   def index_of_posts
     @index_of_posts= Post.order(:title)
     render
   end

   def ads
     render
   end

end
