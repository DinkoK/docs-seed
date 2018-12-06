module Jekyll

  require 'html/pipeline'

  class LangFilter < HTML::Pipeline::Filter

    def call
        doc.css('pre[lang]').each do |node|
            node['data-lang'] = node['lang']
            node.remove_attribute('lang')
        end

        doc
    end

  end

  class RootRelativeFilter < HTML::Pipeline::Filter

    def call
        doc.search('a').each do |a|
            next if a['href'].nil?

            href = a['href'].strip

            if href.start_with? '/'
                a['href'] = context[:baseurl] + href unless href.start_with? context[:baseurl]
            end
        end

        doc.search('img').each do |img|
            next if img['src'].nil?

            src = img['src'].strip

            if src.start_with? '/'
                img['src'] = context[:baseurl] + src unless src.start_with? context[:baseurl]
            end
        end

        doc
    end

  end

  class HeaderLinkFilter < HTML::Pipeline::Filter

      PUNCTUATION_REGEXP = /[^\p{Word}\- ]/u

      def call()

          doc.css('h1, h2, h3').each do |heading|

              desc_node = heading.children.first()
              if desc_node
                  id = desc_node.text
              else
                  id = heading.text
              end

              id = id.downcase.strip
              id.gsub!(PUNCTUATION_REGEXP, '') # remove punctuation
              id.gsub!(' ', '-') # replace spaces with dash

              heading['id'] = id

              a = Nokogiri::XML::Node.new('a', doc)
              a['href'] = "##{id}"

              if desc_node
                  a.children = desc_node
              end

              if next_child = heading.children.first()
                  next_child.before(a)
              else
                  heading.add_child a
              end

          end

          doc
      end
  end

  class Converters::Markdown::MarkdownProcessor
      def initialize(config)
          @config = config
          context = {
            :gfm => false,
            :baseurl => @config['baseurl'],
          }
          
          if @config['code_lang']
            @pipeline = HTML::Pipeline.new [ HTML::Pipeline::MarkdownFilter, LangFilter, RootRelativeFilter, HeaderLinkFilter ], context
          else 
            @pipeline = HTML::Pipeline.new [ HTML::Pipeline::MarkdownFilter, RootRelativeFilter, HeaderLinkFilter ], context
          end
      end

      def convert(content)
          @pipeline.call(content)[:output].to_s
      end
  end

end
