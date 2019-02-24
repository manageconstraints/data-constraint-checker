
def extract_commits(directory, interval=5)
	# reset to the most up to date commit
	`cd #{directory}; git checkout master`
	tags = `cd #{directory}; git tag`
	if tags
		commits = tags.lines.reverse.map{|x| x.strip}
	else
		commits = `python commits.py #{directory}`
		commits = commits.lines
	end
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
	app_name = application_dir.split("/")[-1]
	versions[0].build
	output = open("../log/output_#{app_name}.log", 'w')
	output.write("Total commits: #{versions.length}\n")
	cnt = 0
	for i in 1...versions.length
		#puts "=============#{i}============="
		new_version = versions[i-1]
		version = versions[i]
		version.build
		ncs, ccs = new_version.compare_constraints(version)
		if ncs.length > 0 or ccs.length > 0
			cnt += 1
		end
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
		versions[i-1] = nil
	end
	output.write("cnt: #{cnt}\n")
	output.close
end