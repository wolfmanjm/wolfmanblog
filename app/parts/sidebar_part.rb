class SidebarPart < Merb::PartController

  #
  # To add a new sidebar component, add an action here and the view in views/sidebar_part and add it to the global layout
  #

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

  def recent_posts
    @index_of_posts= Post.reverse_order(:updated_at)
    render
  end

  def ads
    render
  end

  def statics
    @statics= Static.order(:position).all
    render
  end
end
