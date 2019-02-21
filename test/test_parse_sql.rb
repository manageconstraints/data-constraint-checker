require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/parse_sql.rb')
require "test/unit"
require 'yard'

class TestParseSql < Test::Unit::TestCase
  def test_parse_sql
  	contents = "execute \"UPDATE topics SET highest_staff_post_number = highest_post_number\"" 
  	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    assert_equal ['topics', ['highest_staff_post_number']], parse_sql(ast[0][1])
  end
end