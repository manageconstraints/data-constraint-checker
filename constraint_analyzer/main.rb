load 'validate.rb'
load 'read_files.rb'
load 'class_class.rb'
load 'helper.rb'
load 'version.rb'
load 'extract_statistics.rb'
load 'ast_handler.rb'
load 'parse_model_constraint.rb'
load 'parse_db_constraint.rb'
require 'yard'
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string'
application_dir = "/Users/jwy/Research/lobsters-ori/"
load_validate_api
if ARGV[0]
	application_dir = ARGV[0]
	puts "application_dir #{application_dir}"
end
interval = 1
if ARGV[1]
	interval = ARGV[1].to_i
end
traverse_all_versions(application_dir, interval)