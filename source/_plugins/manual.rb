module Jekyll
  class Page
    def sort_name
      dname = @dir.sub(/^\/manual/, '')
      bname = File.basename(@name, ".*")
      if bname == 'index'
        dname
      else
        "#{dname}/#{bname}/"
      end
    end
    # alias orig_permalink permalink
    def permalink
      sort_name.gsub(/\/[0-9]+[_-]/, '/')
    end
  end
end


module Manual
  class ManualGenerator < Jekyll::Generator
    def generate(site)
      site.pages.each do |page| 
        page.data['permalink']  = ''
      end

      puts "Enabling tracing (but run jekyll with --trace)."

      set_trace_func proc {
        |event, file, line, id, binding, classname| 
        if event == "call"  && caller.length > 500
          fail "stack level too deep"
        end
      }
    end
  end

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
