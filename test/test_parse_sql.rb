load '../parse_sql.rb'
require 'yard'

contents = 'execute "UPDATE topics SET highest_staff_post_number = highest_post_number"'
ast = YARD::Parser::Ruby::RubyParser.parse(contents).root