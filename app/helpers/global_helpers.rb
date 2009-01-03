module Merb
  module GlobalHelpers
	# helpers defined here available to all views.

	def sidebars
	  [sb_google_search, sb_contact, sb_links, sb_categories, sb_ads1, sb_ads2]
	end

	def sb_google_search
      str= <<EOS
	  <!-- Search Google -->
	  <center>
	  <form method="get" action="http://www.google.com/custom" target="google_window">
	  <table bgcolor="#ffffff">
	  <tr><td nowrap="nowrap" valign="top" align="left" height="32">

	  <br/>
	  <input type="text" name="q" size="25" maxlength="255" value=""></input>
	  </td></tr>
	  <tr><td valign="top" align="left">
	  <input type="submit" name="sa" value="Google Search"></input>
	  <input type="hidden" name="client" value="pub-9145025475376756"></input>
	  <input type="hidden" name="forid" value="1"></input>
	  <input type="hidden" name="ie" value="ISO-8859-1"></input>
	  <input type="hidden" name="oe" value="ISO-8859-1"></input>
	  <input type="hidden" name="cof" value="GALT:#008000;GL:1;DIV:#336699;VLC:663399;AH:center;BGC:FFFFFF;LBGC:336699;ALC:0000FF;LC:0000FF;T:000000;GFNT:0000FF;GIMP:0000FF;FORID:1"></input>
	  <input type="hidden" name="hl" value="en"></input>
	  </td></tr></table>
	  </form>
	  </center>
	  <!-- Search Google -->
EOS
	  {:title => "Search Internet", :body => str}
	  end

	  def sb_contact
		str= <<EOS
		  <ul><li><b>morris at wolfman dot com</b></li></ul>
EOS
        {:title => "Contact", :body => str}
	  end

	  def sb_links
		str= <<EOS
		 <ul>
         <li><a href="http://www.e4chat.com" title="e4Chat Voice Chat">e4Chat Voice Chat</a></li>
         <li><a href="http://www.wolfman.com">Personal Home page</a></li>
         </ul>
         <a href="http://www.linkedin.com/in/e4net" ><img src="http://www.linkedin.com/img/webpromo/btn_viewmy_160x33.gif" width="160" height="33" border="0" alt="View Jim Morris's profile on LinkedIn"></a>
EOS
		{:title => "Links", :body => str}
	  end

	  def sb_categories
		str= "<ul id=\"categories\">"
		Category.all do |c|
		  str += "<li>#{link_to(c.name, url(:category, c.name))} <em>(#{c.count})</em></li>"
		end
		str += "</ul>"

		{:title => "Categories", :body => str}
	  end

	  def sb_tags

	  end

	  def sb_ads1
	    str= <<EOS
		  <script type="text/javascript"><!--
		google_ad_client = "pub-9145025475376756";
		/* 120x600, blog */
		google_ad_slot = "5272705213";
		google_ad_width = 120;
		google_ad_height = 600;
		//-->
		</script>
		<script type="text/javascript"
		src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
		</script>

		<script type="text/javascript"><!--
		google_ad_client = "pub-9145025475376756";
		/* 120x90, blog */
		google_ad_slot = "3481762934";
		google_ad_width = 120;
		google_ad_height = 90;
		//-->m
		</script>
		<script type="text/javascript"
		src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
		</script>

		<script type="text/javascript"><!--
		google_ad_client = "pub-9145025475376756";
		/* 120x600, blog2 */
		google_ad_slot = "2814292848";
		google_ad_width = 120;
		google_ad_height = 600;
		//-->
		</script>
		<script type="text/javascript"
		src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
		</script>

		<script type="text/javascript"><!--
		google_ad_client = "pub-9145025475376756";
		/* 120x90, blog */
		google_ad_slot = "3481762934";
		google_ad_width = 120;
		google_ad_height = 90;
		//-->
		</script>
		<script type="text/javascript"
		src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
		</script>

		<script type="text/javascript"><!--
		google_ad_client = "pub-9145025475376756";
		/* 120x600, blog2 */
		google_ad_slot = "2814292848";
		google_ad_width = 120;
		google_ad_height = 600;
		//-->
		</script>
		<script type="text/javascript"
		src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
		</script>

		<script type="text/javascript"><!--
		google_ad_client = "pub-9145025475376756";
		/* 120x90, blog */
		google_ad_slot = "3481762934";
		google_ad_width = 120;
		google_ad_height = 90;
		//-->
		</script>
		<script type="text/javascript"
		src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
		</script>
EOS
	  {:title => "Ads", :body => str}
	end

	def sb_ads2
	  str= <<EOS
	  <iframe src="http://rcm.amazon.com/e/cm?t=blogwolfmanco-20&o=1&p=20&l=ur1&category=holidaytoylist&banner=19PHGN8TBRN9ZMXX9F02&f=ifr" width="120" height="90" scrolling="no" border="0" marginwidth="0" style="border:none;" frameborder="0"></iframe>
EOS
	  {:title => "Ads", :body => str}
	end


   end
end