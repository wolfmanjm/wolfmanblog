class SidebarPart < Merb::PartController

  def index
    # define sidebars in the display order
    @sidebars=  [sb_google_search, sb_contact, sb_links, sb_syndicate, sb_categories, sb_tags, sb_recent_comments, sb_index, sb_ads]
    display @sidebars
  end

  private
    # define sidebars
    #
    # types:-
    #   :partial will render a partial with :name => 'partial_name'
    #   nil will render whatever is in :body

    # these helpers one per sidebar, return a hash with the sidebar type, the title and any other info the sidebar needs
    def sb_syndicate
      {:type => :partial, :title => "Syndicate via RSS", :name => 'syndicate'}
    end

    def sb_google_search
      {:type => :partial, :title => "Search Internet", :name => 'google_search'}
    end

    def sb_contact
      {:type => :partial, :title => "Contact", :name => 'contact'}
    end

    def sb_links
      {:type => :partial, :title => "Links", :name => 'links'}
    end

    def sb_categories
      @categories= Category.eager(:posts).all
      {:type => :partial, :title => "Categories", :name => 'categories'}
    end

    # build tag cloud (taken from typo)
    def sb_tags
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

      {:title => "Tags", :body => str}

    end

    def sb_recent_comments
      @comments= Comment.limit(10).order(:created_at.desc).eager(:post).all
      {:type => :partial, :title => "Recent comments", :name => 'recent_comments'}
    end

    def sb_index
      @index_of_posts= Post.order(:title)
      {:type => :partial, :title => "Article Index", :name => 'post_index'}
    end

    def sb_ads
      {:type => :partial, :title => "Ads", :name => 'ads'}
    end

end
