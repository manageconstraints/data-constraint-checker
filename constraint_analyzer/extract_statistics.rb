
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
			#version.build
			versions << version
		end
		i += 1
	end
	return versions
end
def traverse_all_versions(application_dir, interval)
	versions = extract_commits(application_dir, interval)
	versions[0].build
	output = open('../log/output.log', 'w')
	output.write("Total commits: #{versions.length}")
	for i in 1...versions.length
		#puts "=============#{i}============="
		old_version = versions[i-1]
		version = versions[i]
		version.build
		ncs, ccs = version.compare_constraints(old_version)
		model_ncs = ncs.select{|x| x.type == 'validate'}
		db_ncs = ncs.select{|x| x.type == "db"}
		model_ccs = ccs.select{|x| x.type == 'validate'}
		db_ccs = ccs.select{|x| x.type == "db"}
		c1 = model_ncs.length
		c2 = db_ncs.length
		c3 = model_ccs.length
		c4 = db_ccs.length
		output.write("#{ncs.length} #{c1} #{c2} #{ccs.length} #{c3} #{c4}\n")
		ncs.each do|nc|
			#puts "****New****"
			#nc.self_print
		end

		ccs.each do|nc|
			#puts "****DIFF****"
			#nc.self_print
		end
	end
	output.close
end