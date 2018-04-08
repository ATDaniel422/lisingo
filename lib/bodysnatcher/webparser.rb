require 'nokogiri'
require 'open-uri'

require 'bodysnatcher'

class BodySnatcher::WebParser

	attr_accessor :page

	CONTENT_DIVS = "em,strong,b,i,mark,cite,dfn,small,del,ins,sub,sup,#text,span,code,p,li"
	IGNORE_NAMES = "script|style|head|link|meta|button|input|nav|label|img|svg|canvas|ins"
	IGNORE_CLASSES = "head|foot|links|menu|nav|pagetop|subtext|side|notice|overlay|siteSub|infobox|hatnote|abstract|caption|disclaimer|byline"

	def self.content_divs_css
		return CONTENT_DIVS.join(',')
	end

	def initialize(url)
		@page = Nokogiri::HTML(open(url))
	end

	def node_regex(regex, nodes)
		nodes.search("*").select do |node|
			node.name =~ regex || node.attributes.any? do |key,val|
				val.value =~ regex 
			end
		end
	end

	def filter_out(source)
		bad = node_regex(/#{IGNORE_NAMES}|#{IGNORE_CLASSES}/, source)
		bad.each {|node| node.remove()}
	end

	def content_nodes
		filter_out(@page)
		return @page.css(CONTENT_DIVS)
	end

	def content_text
		return content_nodes.text
	end
end
