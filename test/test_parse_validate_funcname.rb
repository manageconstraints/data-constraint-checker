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

  def test_validates_each
    load_validate_api
    table = "Table"
    contents = "validates_each :to_person_id, allow_nil: true do |record, attribute, value|
    if attribute.to_s == 'to_person_id' && value && record.to && record.to.email.nil?
      record.errors.add attribute, :invalid
    end
  end"
    ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    cons = parse_validate_constraint_function(table, "validates_each", ast[0][1])
    constraint = cons[0]
    key = "#{constraint.column}-#{constraint.class.name}-#{constraint.type}"
    puts key
    assert_equal 1, cons.length
  end
end