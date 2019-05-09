require File.join(File.expand_path(File.dirname(__FILE__)), 'required_file.rb')
class TestValidataConstraint < Test::Unit::TestCase
  def test_validate
    load_validate_api # load the model api
    table = "Table"
    contents = "validate :function"
    ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    cons = parse_validate_constraint_function(table, "validate", ast[0][1])
    assert_equal 1, cons.length
    assert_equal cons[0].class.name, "Function_constraint"
  end
end