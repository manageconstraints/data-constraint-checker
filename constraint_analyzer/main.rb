load 'validate.rb'
load 'parse_constraint.rb'
load 'read_files.rb'
load 'class_class.rb'
load 'helper.rb'
load 'version.rb'
application_dir = "/Users/jwy/Research/lobsters-ori/"
load_validate_api
#read_ruby_files(application_dir)

def extract_commits(directory, interval=5)
	# reset to the most up to date commit
	`cd #{directory}; git checkout master`
	commits = `python commits.py #{directory}`
	commits = commits.lines.reverse
	puts "commits.length: #{commits.length}"
	versions = []
	i = 0
	commits.each do |commit|
		if i % interval == 0
			version = Version.new(directory, commit)
			version.build
			versions << version
		end
		i += 1
	end
	return versions
end
def traverse_all_versions(application_dir, interval)
	versions = extract_commits(application_dir, interval)
	version = versions[-1]
	for i in 1...versions.length
		puts "=============#{i}============="
		old_version = versions[i-1]
		version = versions[i]
		ncs, ccs = version.compare_constraints(old_version)
		ncs.each do|nc|
			puts "****New****"
			nc.self_print
		end

		ccs.each do|nc|
			puts "****DIFF****"
			nc.self_print
		end
	end
end
traverse_all_versions(application_dir, 10)