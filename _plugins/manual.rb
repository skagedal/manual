require 'find'

module Manual
  
  def Manual.make_permalink (s)
    ('/' + s).gsub(/\/\d+[-_]/, '/').sub(/\.html$/, '/')
  end

  def Manual.child_url?(a, b)
    a.start_with?(b) && b.count('/') + 1 == a.count('/')
  end

  def Manual.find_children (url, site)
    site.pages.select{ |p| child_url?(p.url, url) }.sort_by{ |p| p.basename }
  end

  class ManualPage < Jekyll::Page
    def initialize(*args)
      super
    end

    def child_to_url?(parent_url)
      url.start_with?(parent_url) && parent_url.count('/') + 1 == url.count('/')
    end

    def child_to?(parent)
      child_to_url?(parent.url)
    end

    def children()
      @site.pages.select{ |p| p.child_to?(self) }.sort_by{ |p| p.dir }
    end
  end

  class ManualGenerator < Jekyll::Generator
    def generate(site)
      source = Pathname.new (site.config['source'])

      Dir.chdir (source) do

        manual_dir = Pathname.new('_manual/.')

        manual_dir.find do |path|
          if path.file? 
            puts path
            plink = Manual.make_permalink(path.relative_path_from(manual_dir).to_s)
         
            page = ManualPage.new(site, '', path.dirname.to_s, path.basename.to_s)
            page.data['permalink'] = plink

            site.pages << page
          end
        end
      end
    end
  end

  # generates a big <dl> list of the manual page stucture

  class Tag_tree < Liquid::Tag
    def render(context)
      ""
    end
  end

  class Tag_children < Liquid::Tag
    def render(context)
      page = context.registers[:page]       # for some stupid reason this is not a Jekyll::Page object
      site = context.registers[:site]
      children = Manual.find_children(page['url'], site)
      entries = children.map do |child|
        url, title = child.url, child.data['title']
        "<li><a href='#{url}'>#{title}</a></li>"
      end

      "<div id='subtopics'>
        <h2>This chapter covers the following topics:</h2>
        <ul>
          #{entries.join}
        </ul>
        </div>
      "
    end
  end

end

Liquid::Template.register_tag('tree', Manual::Tag_tree) 
Liquid::Template.register_tag('children', Manual::Tag_children) 
