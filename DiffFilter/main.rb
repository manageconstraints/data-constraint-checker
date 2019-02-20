load 'validate.rb'
load 'parse_constraint.rb'
load 'read_files.rb'
load 'class_class.rb'
load 'helper.rb'
load 'version.rb'
application_dir = "/Users/jwy/Research/fulcrum-ori/"
load_validate_api
#read_ruby_files(application_dir)

def extract_commits(directory)
	# reset to the most up to date commit
	`cd #{directory}; git checkout master`
	commits = `python commits.py #{directory}`
	commits = commits.lines.reverse
	puts "commits.length: #{commits.length}"
	versions = []
	commits.each do |commit|
		version = Version.new(directory, commit)
		versions << version
	end
	return versions
end
versions = extract_commits(application_dir)
version = versions[-1]
version.extract_files
version.annotate_model_class
version.extract_constraints
version.print_columns
old_version = versions[100]
old_version.extract_files
old_version.annotate_model_class
old_version.extract_constraints

ncs = version.compare_constraints(old_version)
ncs.each do|nc|
	puts "****DIFF****"
	nc.self_print
end


