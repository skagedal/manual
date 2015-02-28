require 'find'

module Manual
  
  def Manual.make_permalink (s)
    ('/' + s).gsub(/\/\d+[-_]/, '/').sub(/\.html$/, '/')
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
         
            page = Jekyll::Page.new(site, '', path.dirname.to_s, path.basename.to_s)
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
      ""
    end
  end

end

Liquid::Template.register_tag('tree', Manual::Tag_tree) 
Liquid::Template.register_tag('children', Manual::Tag_children) 
