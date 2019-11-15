
require File.join(File.expand_path(File.dirname(__FILE__)), 'required_file.rb')

class TestParseModelConstriant < Test::Unit::TestCase

  def test_parse_confirmation
  	contents = "validates :email, confirmation: true" 
  	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    c = parse_validates("Person", "validates", ast[0][1])
  	assert_equal 1, c.length
  	assert_equal c[0]&.class.name, 'Confirmation_constraint'
  end

  def test_parse_confirmation2
  	contents = "validates :email, confirmation: true" 
  	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    c = parse_validate_constraint_function("Person", "validates",ast[0][1])
  	assert_equal 1, c.length
  	assert_equal c[0]&.class.name, 'Confirmation_constraint'
  end

  def test_parse_multiple_constraints
  	contents = "validates :email,
													 :format => { :with => /\A[^@ ]+@[^@ ]+\.[^@ ]+\Z/ },
													 :uniqueness => { :case_sensitive => false }"
 		ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    c = parse_validate_constraint_function("Person", "validates",ast[0][1])
  	assert_equal c[0]&.class.name, 'Format_constraint'
		assert_equal c[1]&.class.name, 'Uniqueness_constraint'
  	assert_equal false, c[1]&.case_sensitive
    assert_equal 2, c.length

  end

	def test_parse_confirmation_with_hash
		contents = "validates :email, confirmation: { case_sensitive: false }"
		ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
		c = parse_validate_constraint_function("Person", "validates",ast[0][1])
		assert_equal 1, c.length
		assert_equal c[0]&.class.name, 'Confirmation_constraint'
		assert_equal false, c[0]&.case_sensitive
	end

  def test_parse_length_with_hash
  	contents = "validates :name, length: { minimum: 2 }"
  	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    c = parse_validate_constraint_function("Person", "validates",ast[0][1])
  	assert_equal 1, c.length
  	assert_equal c[0]&.class.name, 'Length_constraint'
  	assert_equal c[0]&.min_value, 2
  end
  def test_parse_numericality1
  	contents = "validates :games_played, numericality: { only_integer: true }"
  	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    c = parse_validate_constraint_function("Person", "validates",ast[0][1])
  	assert_equal 1, c.length
  	assert_equal c[0]&.class.name, 'Numericality_constraint'
  	assert_equal c[0]&.only_integer, true
  end
  def test_parse_numericality2
  	contents = "validates :points, numericality: true"
  	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    c = parse_validate_constraint_function("Person", "validates",ast[0][1])
  	assert_equal 1, c.length
  	assert_equal c[0]&.only_integer, nil
  	assert_equal c[0]&.class.name, 'Numericality_constraint'
  end

  def test_parse_uniqueness1
  	contents = "validates :name, uniqueness: { case_sensitive: false }"
 	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    c = parse_validate_constraint_function("Person", "validates",ast[0][1])
  	assert_equal 1, c.length
  	assert_equal false, c[0]&.case_sensitive
  	assert_equal c[0]&.class.name, 'Uniqueness_constraint'
  end
  def test_parse_acceptance1
  	contents = "validates :terms_of_service, acceptance: true"
 	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    c = parse_validate_constraint_function("Person", "validates",ast[0][1])
  	assert_equal 1, c.length
  	assert_equal [], c[0]&.accept_condition
  	assert_equal c[0]&.class.name, 'Acceptance_constraint'
  end
   def test_parse_acceptance2
  	contents = "validates :terms_of_service, acceptance: { accept: 'yes' }"
 	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    c = parse_validate_constraint_function("Person", "validates",ast[0][1])
  	assert_equal 1, c.length
  	assert_equal ['yes'], c[0]&.accept_condition
  	assert_equal c[0]&.class.name, 'Acceptance_constraint'
  end
  def test_parse_acceptance3
  	contents = "validates :eula, acceptance: { accept: ['TRUE', 'accepted'] }"
 	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    c = parse_validate_constraint_function("Person", "validates",ast[0][1])
  	assert_equal 1, c.length
  	assert_equal ['TRUE', 'accepted'], c[0]&.accept_condition
  	assert_equal c[0]&.class.name, 'Acceptance_constraint'
  end
  def test_parse_acceptance4
  	contents = "validates_acceptance_of :terms_of_service"
 	  ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    c = parse_validate_constraint_function("Person", "validates_acceptance_of",ast[0][1])
  	assert_equal 1, c.length
  	assert_equal [], c[0]&.accept_condition
  	assert_equal c[0]&.class.name, 'Acceptance_constraint'
  end
  def test_parse_nested_class
    contents = "class TopicInvite < ActiveRecord::Base
                    class B
                    end
                    belongs_to :topic
                    belongs_to :invite

                    validates_presence_of :topic_id
                    validates_presence_of :invite_id

                    validates_uniqueness_of :topic_id, scope: :invite_id
                    has_many :attachments, dependent: :destroy
                    has_many :users
                    belongs_to :test, optional: true
                  end"
    load_validate_api
    ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    $cur_class = File_class.new("file")
    $classes = []
    $module_name = ""
    parse_model_constraint_file(ast) 
    cons = $cur_class.getConstraints 
    puts "#{$cur_class.class_name}"    
    puts "c #{cons.size}"
    assert_equal 2, $cur_class.has_many_classes.size
    assert_equal true, $cur_class.has_many_classes["attachments"]
    assert_equal false, $cur_class.has_many_classes["users"]
    
  end     
end
