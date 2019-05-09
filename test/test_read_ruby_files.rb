require File.join(File.expand_path(File.dirname(__FILE__)), 'required_file.rb')

class TestHTMLConstraint < Test::Unit::TestCase
  def test_read_erb_files
    application_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'erb_file')
    read_constraint_files(application_dir)
    test_filename = application_dir + "/app/views/recurring_todos/_edit_form.html.erb"
    assert_equal $cur_class.filename, test_filename
  end
  def test_read_haml_files
    application_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'haml_file')
    test_filename = application_dir + "/app/views/people/_form_basics.haml"
    read_constraint_files(application_dir)
    assert_equal $cur_class.filename, test_filename
  end
  def test_parse_html_erb_file
    puts "test_parse_html_erb_file"
    application_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'erb_file')
    test_filename = application_dir+"/app/views/recurring_todos/_edit_form.html.erb"
    load_html_constraint_api
    table_class = File_class.new("app/views/recurring_todo.rb")
    table_class.class_name = "RecurringTodo"
    column = Column.new(table_class, 'description', 'string', nil, {})
    table_class.addColumn(column)
    $model_classes = {}
    $model_classes["RecurringTodo"] = table_class
    read_html_file_ast([test_filename])
    assert_equal table_class.getConstraints.size, 1
    constraint = table_class.getConstraints.values[0]
    assert_equal "description", constraint.column
  end
  def test_parse_html_erb_file2
    puts "test_parse_html_erb_file"
    application_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'erb_file2')
    test_filename = application_dir+"/app/views/todos/_edit_form.rhtml"
    load_html_constraint_api
    table_class = File_class.new("app/views/todos/_edit_form.rhtml")
    table_class.class_name = "Todo"
    column = Column.new(table_class, 'description', 'string', nil, {})
    table_class.addColumn(column)
    $model_classes = {}
    $model_classes["Todo"] = table_class
    read_html_file_ast([test_filename])
    assert_equal table_class.getConstraints.size, 1
    constraint = table_class.getConstraints.values[0]
    assert_equal "description", constraint.column
    assert_equal "Todo", constraint.table
  end
  def test_parse_haml_file
    puts "test_parse_haml_file"
    application_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'haml_file')
    test_filename = application_dir + "/app/views/people/_form_basics.haml"
    load_html_constraint_api
    table_class = File_class.new("app/views/people/_form_basics.haml")
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
    table_class = File_class.new("app/views/registrations/_form.haml")
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
    constraints = table_class.getConstraints
    format_constraints = constraints.select{|k, x| x.class.name == "Format_constraint"}.map{|k,v| v}
    presence_constraints = constraints.values.select{|x| x.class.name == "Presence_constraint"}
    puts "constraints.length #{constraints.length}"
    assert_equal presence_constraints.size, 4
    assert_equal format_constraints.size, 3
    assert_equal format_constraints[0].with_format, "[A-Za-z0-9_]+"
    assert_equal format_constraints[1].with_format, "......+"
    assert_equal format_constraints[2].with_format, "......+"
  end

end