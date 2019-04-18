require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/parse_sql.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/validate.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/parse_model_constraint.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/parse_html_constraint.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/parse_db_constraint.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/read_files.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/class_class.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/helper.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/version_class.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/extract_statistics.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/ast_handler.rb')
require "test/unit"
require 'yard'
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string'
class TestHeplerConstraint < Test::Unit::TestCase
  def test_derive_length_constraint_from_format
      format = "......+"
      constraint = Format_constraint.new("", "", "")
      constraint.with_format = format
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.class.name, "Length_constraint"
      assert_equal len_constraint.min_value, 6
      constraint.with_format = "[a-z]"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 1
      assert_equal len_constraint.max_value, 1
      constraint.with_format = "[a-z]*"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 0
      assert_equal len_constraint.max_value, nil
      constraint.with_format = "[a-z]+"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 1
      assert_equal len_constraint.max_value, nil
      constraint.with_format = "c{1,2}"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 1
      assert_equal len_constraint.max_value, 2
      constraint.with_format = "ac{1,2}"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 2
      assert_equal len_constraint.max_value, 3
      constraint.with_format = "ac{1,}"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 2
      assert_equal len_constraint.max_value, nil
      constraint.with_format = "[a-z]{1,}"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 1
      assert_equal len_constraint.max_value, nil
      constraint.with_format = "[1-2]{1,2}[a-z]{1,}"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 2
      assert_equal len_constraint.max_value, nil
      constraint.with_format = "[1-2]{1,2}[a-z]{1,5}"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 2
      assert_equal len_constraint.max_value, 7
      constraint.with_format = "[1-2]{1,2}[a-z]{1}"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 2
      assert_equal len_constraint.max_value, 3
      constraint.with_format = "[1-2]{1,2}c[a-z]{1}"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 3
      assert_equal len_constraint.max_value, 4
      constraint.with_format = "[1-2]{1,2}c+[a-z]{1}"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 3
      assert_equal len_constraint.max_value, nil
      constraint.with_format = "[1-2]{1,2}c*[a-z]{1}"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 2
      assert_equal len_constraint.max_value, nil
      constraint.with_format = "[1-2]{2}c[a-z]{1}"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 4
      assert_equal len_constraint.max_value, 4
      constraint.with_format = "[1-2]+c[a-z]{1}"
      len_constraint = derive_length_constraint_from_format(constraint)
      assert_equal len_constraint.min_value, 3
      assert_equal len_constraint.max_value, nil
  end



end