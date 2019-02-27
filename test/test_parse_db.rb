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
class TestParseModelConstriant < Test::Unit::TestCase
  def test_parse_confirmation
  	contents = "class ChangeProductsPrice < ActiveRecord::Migration[5.0]
                def change
                  reversible do |dir|
                    change_table :products do |t|
                      dir.up   { t.change :price, :string }
                      dir.down { t.change :price, :integer }
                    end
                  end
                end
              end" 
  	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    model_class = Class_class.new("products.rb")
    model_class.class_name = "Product"
    model_class.upper_class_name == "ActiveRecord::Base"
    model_class.is_activerecord = true
    $model_classes = {}
    $model_classes[model_class.class_name] = model_class
    $cur_class = Class_class.new("test.rb")
    $cur_class.ast = ast
    parse_db_constraint_file(ast)  
    assert_equal 1, model_class.getColumns.length
    assert_equal 0, model_class.getConstraints.length
  end
end
