require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/parse_sql.rb")
require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/validate.rb")
require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/parse_model_constraint.rb")
require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/parse_model_metadata.rb")
require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/parse_controller_file.rb")
require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/parse_html_constraint.rb")
require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/parse_db_constraint.rb")
require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/read_files.rb")
require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/class_class.rb")
require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/helper.rb")
require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/version_class.rb")
require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/extract_statistics.rb")
require File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/ast_handler.rb")
require "optparse"
require "yard"
require "active_support"
require "active_support/inflector"
require "active_support/core_ext/string"
require "regexp-examples"
application_dir = "/Users/jwy/Research/lobsters-ori/"
load_validate_api # load the model api
load_html_constraint_api #load the html api
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-a", "--app app", "please specify application dir") do |v|
    options[:app] = v
    puts "v #{v}"
  end

  opts.on("-i", "--interval interval", "please specify interval") do |v|
    options[:interval] = v.to_i
  end
  opts.on("-t", "--tva", "whether to traverse all") do |v|
    options[:tva] = true
    puts "will travese_all_versions"
  end
  opts.on("-s", "--single", "whether to parse single version") do |v|
    options[:single] = true
  end
  opts.on("-m", "--all_mismatch", "please specify whether you want to find all versions' mismatch") do |v|
    options[:mismatch] = true
  end
  opts.on("-l", "--latest-version", "please specify that you want to get the current versions breakdown") do |v|
    options[:latest] = true
  end
  opts.on("--first-last-num", "please specify that you want to compare the first and last verison constraint num") do |v|
    options[:fln] = true
  end
  opts.on("--commit-unit", "please specify whether using commit as unit") do |v|
    options[:commit_unit] = true
  end
  opts.on("--api-breakdown", "please specify whether to get the API breakdown") do |v|
    options[:api_breakdown] = true
  end
  opts.on("--custom-error-msg", "please specify whether to get custom error messages") do |v|
    options[:custom_error_msg] = true
  end
  opts.on("--curve", "please specify whether you want the curve of # constraints # loc") do |v|
    options[:curve] = true
  end
  opts.on("--pvf", "please specify whether you want to print the validation functions") do |v|
    options[:pvf] = true
  end
  opts.on("--commit-hash", "please specify whether you want to get the commit hash") do |v|
    options[:commit_hash] = true
  end
end.parse!

if options[:app]
  application_dir = options[:app]
  puts "application_dir #{application_dir}"
end
interval = 1
if options[:interval]
  interval = options[:interval].to_i
end
if options[:tva] and options[:app] and interval
  puts "travese_all_versions start options[:commit_unit] #{options[:commit_unit]}"
  if options[:commit_unit]
    traverse_all_versions(application_dir, interval, false)
  else
    traverse_all_versions(application_dir, interval, true)
  end
end
if options[:single] and options[:app]
  find_mismatch_oneversion(options[:app])
end
if options[:mismatch] and options[:app]
  puts "interval parse: #{interval.class.name}"
  find_all_mismatch(options[:app], interval)
end
if options[:latest] and application_dir
  current_version_constraints_num(application_dir)
end
if options[:fln] and application_dir
  first_last_version_comparison_on_num(application_dir)
end
if options[:api_breakdown] and application_dir
  api_breakdown(application_dir)
end
if options[:custom_error_msg] and application_dir
  custom_error_msg_info(application_dir)
end

if options[:curve] and application_dir
  interval = 100
  puts "interval #{interval}"
  traverse_constraints_code_curve(application_dir, interval, false)
end

if options[:pvf] and application_dir
  puts "print validation function"
  print_validate_functions(application_dir)
end

if options[:commit_hash] and application_dir
  puts `cd #{application_dir}; git rev-parse HEAD`
end
