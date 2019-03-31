load 'validate.rb'
load 'read_files.rb'
load 'class_class.rb'
load 'helper.rb'
load 'version.rb'
load 'extract_statistics.rb'
load 'ast_handler.rb'
load 'parse_model_constraint.rb'
load 'parse_db_constraint.rb'
require 'optparse'
require 'yard'
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string'
application_dir = "/Users/jwy/Research/lobsters-ori/"
load_validate_api
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
  end
  opts.on("-s", "--single", "whether to parse single version") do |v|
    options[:single] = true
  end

end.parse!


if options[:app]
	application_dir = options[:app]
	puts "application_dir #{application_dir}"
end
interval = 1
if options[:interval]
	interval = options[:interval]
end
if options[:tva] and options[:app] and interval
	traverse_all_versions(application_dir, interval)
end
if options[:single] and options[:app]
	find_mismatch_oneversion(options[:app])
end