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
class TestVersionClassConstraint < Test::Unit::TestCase
  def test_extract_uniquess_columns
    load_validate_api # load the model api
    load_html_constraint_api #load the html api
    app_dir = File.join(File.expand_path(File.dirname(__FILE__)), '../apps/lobsters')
    version = Version_class.new(app_dir, "")
    version.build
    ci_columns = version.extract_case_insensitive_columns
    puts "ci_columns.size： #{ci_columns.size}"
  end
end