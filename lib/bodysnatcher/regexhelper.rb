class BodySnatcher::RegexHelper
	def regex_any node_set, regex_string
		#! node_set.select { |node| node.content =~ /#{regex_string}/ }.empty?
		p node_set
		! node_set.attributes.any? { |key,value|
			value =~ /#{regex_string}/
		}	
	end
end
