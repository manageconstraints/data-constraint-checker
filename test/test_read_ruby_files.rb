require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/parse_sql.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/validate.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/parse_model_constraint.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/parse_db_constraint.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/read_files.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/class_class.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/helper.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/version.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/extract_statistics.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/ast_handler.rb')
require "test/unit"
require 'yard'
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string'
class TestReadFiles < Test::Unit::TestCase
  def test_read_erb_files
    application_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'erb_file')
    puts application_dir
    read_ruby_files(application_dir)
    assert_equal 
  end
  def test_read_haml_files
    application_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'haml_file')
    read_ruby_files(application_dir)
  end
end