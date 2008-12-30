require 'syntax/convertors/html'

class Post < Sequel::Model
  is :timestamped
  has_many :comments

  validates do
	presence_of :title, :body
  end

  before_create do
	self.permalink= title.to_url
  end

  def to_html
	doc= BlueCloth::new(convert(body))
	doc.to_html
  end

  def self.find_by_permalink(title)
	filter(:permalink => title).first
  end

  private

  # find <typo:code lang="ruby"> ... </typo:code> blocks and use syntax to convert the enclosed code to html
  def convert(bod)
	if bod =~ /<typo:code\s+lang="(.*)">/
	  lang= $1
	  convertor = Syntax::Convertors::HTML.for_syntax lang
	  in_code= false
	  b= ""
	  code= ""
	  bod.each_line do |l|
		if in_code
		  if l =~ /^<\/typo:code>/
			in_code= false
			text = convertor.convert( code )
			b += text
		  else
			code += l
		  end
		elsif l =~ /^<typo:code/
		  in_code= true
		  code= ""
		else
		  b += l
		end
	  end
	  b
	else
	  bod
	end
  end

end
