require 'erb'
require 'fileutils'
require 'tmpdir'
require 'pp'

module Manual

  class ManualGenerator < Jekyll::Generator
    def generate(site)
      puts "Pages: ", site.pages.length
      site.pages.each do |page|
        puts " - #{page.name} (name):"
        puts "   - base:      #{page.basename}"
        puts "   - dir:       #{page.dir}"
        puts "   - data:      #{page.data}"
        puts "   - url:       #{page.url}"
        page.data['permalink'] = '/trams' + page.url
        puts "   - permalink: #{page.permalink}"
        puts "   - url:       #{page.url}"
      end
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
