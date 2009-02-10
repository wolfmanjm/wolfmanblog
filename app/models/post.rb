require 'syntax/convertors/html'

class Post < Sequel::Model
  is :timestamped
  has_many :comments
  many_to_many :tags
  many_to_many :categories
  
  validates do
    presence_of :title, :body
  end

  before_create do
    self.permalink= title.to_url if title
    self.guid= UUID.random_create
  end

  def to_html
    doc= BlueCloth::new(convert(body))
    doc.to_html
  end

  def comments_size
    Comment.filter(:post_id => id).count
  end

  def self.find_by_permalink(title)
    filter(:permalink => title).first
  end

  def categories_csv
    categories.collect{ |c| c.name}.join(',') unless id.nil?
  end

  def tags_csv
    tags.collect{ |t| t.name}.join(',') unless id.nil?
  end

  # update the categories and tags with a comma separated list
  def update_categories_and_tags(cats, tags)
    remove_all_categories
    remove_all_tags

    unless cats.empty?
      cats.split(',').each do |c|
        cat= Category.find_or_create(:name => c.strip)
        add_category(cat)
      end
    end
    unless tags.empty?
      tags.split(',').each do |t|
        tag= Tag.find_or_create(:name => t.strip)
        add_tag(tag)
      end
    end
  end

  def year
    created_at.year
  end

  def month
    created_at.month
  end

  def day
    created_at.day
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
