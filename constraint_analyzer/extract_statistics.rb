
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
			versions << version if version
		end
		i += 1
	end
	return versions
end
def traverse_all_versions(application_dir, interval)
	versions = extract_commits(application_dir, interval)
	return if versions.length <= 0
	app_name = application_dir.split("/")[-1]
	versions[0].build
	output = open("../log/output_#{app_name}.log", 'w')
	cnt = 0
	sum1 = 0
	sum2 = 0
	sum3 = 0
	sum4 = 0
	sum5 = 0
	sum6 = 0
	sum7 = 0
	sum8 = 0
	for i in 1...versions.length
		#puts "=============#{i}============="
		new_version = versions[i-1]
		version = versions[i]
		version.build
		ncs, ccs, eccs, nccs = new_version.compare_constraints(version)
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
		model_eccs = eccs.select{|x| x.type == 'validate'}
		db_eccs = eccs.select{|x| x.type == "db"}
		model_nccs = nccs.select{|x| x.type == 'validate'}
		db_nccs = nccs.select{|x| x.type == "db"}
		c5 = model_eccs.length
		c6 = db_eccs.length
		c7 = model_nccs.length
		c8 = db_nccs.length
		sum1 += c1
		sum2 += c2
		sum3 += c3
		sum4 += c4
		sum5 += c5
		sum6 += c6
		sum7 += c7
		sum8 += c8
		versions[i-1] = nil
		
	end
	output.write("#{versions.length} #{cnt} #{sum1} #{sum2} #{sum3} #{sum4} #{sum5} #{sum6} #{sum7} #{sum8}")
	output.close
end

def find_mismatch_oneversion(directory)
	`cd #{directory}; git checkout master`
	commit = "master"
	version = Version.new(directory, commit)
	version.build
	version.compare_self
end