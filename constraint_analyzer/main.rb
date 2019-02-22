load 'validate.rb'
load 'parse_constraint.rb'
load 'read_files.rb'
load 'class_class.rb'
load 'helper.rb'
load 'version.rb'
load 'extract_statistics.rb'
application_dir = "/Users/jwy/Research/lobsters-ori/"
load_validate_api

traverse_all_versions(application_dir, 1)