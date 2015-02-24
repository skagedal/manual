module Jekyll
  class Page
    def sort_name_fooo
      d = dir.sub(/^\/manual/, '')
      basename == 'index' ? d : "#{d}/#{basename}/"
    end
    alias orig_permalink permalink
    def permalink
      # sort_name.gsub(/\/[0-9]+[_-]/, '/')
      permalink = orig_permalink
      newPermalink = "/hej/#{permalink}"
    end
  end
end


module Manual

=begin
  class ManualGenerator < Jekyll::Generator
    def generate(site)
      puts "Pages: ", site.pages.length
      site.pages.sort_by { |p| p.sort_name }.each do |page|
        puts " - #{page.url}"

        puts " - #{page.name} (name):"
        puts "   - base:       #{page.basename}"
        puts "   - dir:        #{page.dir}"
        puts "   - url:        #{page.url}"
        puts "   - sort:       #{page.sort_name}"
        puts "   - tmp_:       #{page.tmp_permalink}"
      end
    end
  end
=end

  class ManualChildPageTag < Liquid::Tag
    def render(context)
      "<div id='subtopics'>
        <h2>This chapter covers the following topics:</h2>
        <ul>
          <li>Foo</li>
        </ul>
        </div>
        "
    end
  end

  # generates a big <dl> list of the manual page stucture

  class ManualTOCTag < Liquid::Tag

    def render(context)
      "<dl><li>Tree</li></dl>
      <script type='text/javascript'>
      //<![CDATA[
        offset = document.getElementsByClassName('active')[0].offsetTop;
        height = document.getElementById('tree').clientHeight;
        if (offset > (height * .7)) {
          tree.scrollTop = offset - height * .3;
        }
      //]]>
      </script>"

    end

  end

end

Liquid::Template.register_tag('tree', Manual::ManualTOCTag) 
Liquid::Template.register_tag('children', Manual::ManualChildPageTag) 
