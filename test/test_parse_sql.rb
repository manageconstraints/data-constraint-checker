require File.join(File.expand_path(File.dirname(__FILE__)), 'required_file.rb')


class TestParseSql < Test::Unit::TestCase
  def test_parse_sql
  	contents = "execute \"UPDATE topics SET highest_staff_post_number = highest_post_number\"" 
  	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    assert_equal ['topics', ['highest_staff_post_number']], parse_sql(ast[0][1])
  end

  def test_handle_cross_string
  	contents =     "execute <<-SQL
      UPDATE email_logs
         SET user_id = u.id
        FROM email_logs el
   LEFT JOIN users u ON u.email = el.to_address
       WHERE email_logs.id = el.id
         AND email_logs.user_id IS NULL
         AND NOT email_logs.skipped
    SQL"
    output = "      UPDATE email_logs
         SET user_id = u.id
        FROM email_logs el
   LEFT JOIN users u ON u.email = el.to_address
       WHERE email_logs.id = el.id
         AND email_logs.user_id IS NULL
         AND NOT email_logs.skipped\n"
    ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    sql = handle_cross_line_string(ast[0][1][0][0].source)
    assert_equal  sql, output
    assert_equal ['email_logs', ['user_id']], parse_sql(ast[0][1])
  end
  def test_handle_cross_string2
    contents = "execute <<-SQL
          ALTER TABLE distributors
            ADD CONSTRAINT zipchk
              CHECK (char_length(zipcode) = 5) NO INHERIT;
        SQL"
    output = "          ALTER TABLE distributors
            ADD CONSTRAINT zipchk
              CHECK (char_length(zipcode) = 5) NO INHERIT;\n"
    ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    sql = handle_cross_line_string(ast[0][1][0][0].source)
    assert_equal  sql, output
    puts "parse_sql(ast[0][1]) #{parse_sql(ast[0][1])}"
  end
end