require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/parse_sql.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/validate.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/parse_model_constraint.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '../constraint_analyzer/parse_html_constraint.rb')
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
class TestHTMLConstraint < Test::Unit::TestCase
  def test_read_erb_files
    application_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'erb_file')
    read_ruby_files(application_dir)
    test_filename = application_dir + "/app/views/recurring_todos/_edit_form.html.erb"
    assert_equal $cur_class.filename, test_filename
  end
  def test_read_haml_files
    application_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'haml_file')
    test_filename = application_dir + "/app/views/people/_form_basics.haml"
    read_ruby_files(application_dir)
    assert_equal $cur_class.filename, test_filename
  end
  def test_parse_html_erb_file
    puts "test_parse_html_erb_file"
    application_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'erb_file')
    test_filename = application_dir+"/app/views/recurring_todos/_edit_form.html.erb"
    load_html_constraint_api
    table_class = Class_class.new("app/views/recurring_todo.rb")
    table_class.class_name = "RecurringTodo"
    column = Column.new(table_class, 'description', 'string', nil, {})
    table_class.addColumn(column)
    $model_classes = {}
    $model_classes["RecurringTodo"] = table_class
    read_html_file_ast([test_filename])
    assert_equal table_class.getConstraints.size, 1
  end
  def test_parse_haml_file
    puts "test_parse_haml_file"
    application_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'haml_file')
    test_filename = application_dir + "/app/views/people/_form_basics.haml"
    load_html_constraint_api
    table_class = Class_class.new("app/views/people/_form_basics.haml")
    table_class.class_name = "Person"
    column = Column.new(table_class, 'description', 'string', nil, {})
    table_class.addColumn(column)
    $model_classes = {}
    $model_classes["Person"] = table_class
    read_html_file_ast([test_filename])
    assert_equal table_class.getConstraints.size, 1
  end
  def test_parse_haml_file2
    puts "test_parse_haml_file2"
    application_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'haml_file2')
    test_filename = application_dir + "/app/views/registrations/_form.haml"
    load_html_constraint_api
    table_class = Class_class.new("app/views/registrations/_form.haml")
    table_class.class_name = "User"
    column = Column.new(table_class, 'username', 'string', nil, {})
    table_class.addColumn(column)
    column2 = Column.new(table_class, 'password', 'string', nil, {})
    table_class.addColumn(column2)
    column3 = Column.new(table_class, 'password_confirmation', 'string', nil, {})
    table_class.addColumn(column3)
    $model_classes = {}
    $model_classes["User"] = table_class
    read_html_file_ast([test_filename])
    assert_equal table_class.getConstraints.size, 3
    assert_equal table_class.getConstraints.values[0].with_format, "[A-Za-z0-9_]+"
    assert_equal table_class.getConstraints.values[1].with_format, "......+"
    assert_equal table_class.getConstraints.values[2].with_format, "......+"
  end

end