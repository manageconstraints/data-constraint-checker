require File.join(File.expand_path(File.dirname(__FILE__)), 'required_file.rb')

class TestVersionClassConstraint < Test::Unit::TestCase
  def test_extract_uniquess_columns
    load_validate_api # load the model api
    load_html_constraint_api #load the html api
    app_dir = File.join(File.expand_path(File.dirname(__FILE__)), '../apps/lobsters')
    version = Version_class.new(app_dir, "")
    version.build
    ci_columns = version.extract_case_insensitive_columns
    assert_equal 2, ci_columns.size
  end
  def test_extract_uniquess_columns_redmine
    load_validate_api # load the model api
    load_html_constraint_api #load the html api
    app_dir = File.join(File.expand_path(File.dirname(__FILE__)), '../apps/redmine')
    version = Version_class.new(app_dir, "")
    version.build
    ci_columns = version.extract_case_insensitive_columns
    puts "ci_columns.size： #{ci_columns.size}"
    puts "#{ci_columns.keys.join(", ")}"
  end
end