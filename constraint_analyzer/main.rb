load 'validate.rb'
load 'parse_constraint.rb'
load 'read_files.rb'
load 'class_class.rb'
load 'helper.rb'
load 'version.rb'
load 'extract_statistics.rb'
application_dir = "/Users/jwy/Research/lobsters-ori/"
load_validate_api
if ARGV[0]
	application_dir = ARGV[0]
	puts "application_dir #{application_dir}"
end
traverse_all_versions(application_dir, 1)