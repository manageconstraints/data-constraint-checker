
def extract_commits(directory, interval=5)
	# reset to the most up to date commit
	puts "cd #{directory}; git checkout master"
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
			version = Version_class.new(directory, commit)
			#version.build
			versions << version if version
		end
		i += 1
	end
	return versions
end

def traverse_all_versions(application_dir, interval)
	versions = extract_commits(application_dir, interval)
	puts "versions.length: #{versions.length}"
	return if versions.length <= 0
	app_name = application_dir.split("/")[-1]
	versions[0].build
	output = open("../log/output_#{app_name}.log", 'w')
  log_dir = "../log/#{app_name}_log/"
  `mkdir #{log_dir} -p`
  output_html_constraints = open("#{log_dir}/html_constraints.log", 'a+')
	cnt = 0
	sum1 = 0
	sum2 = 0
	sum3 = 0
	sum4 = 0
	sum5 = 0
	sum6 = 0
	sum7 = 0
	sum8 = 0
  sumh1 = 0
  sumh2 = 0
  sumh3 = 0
  sumh4 = 0
	for i in 1...versions.length
		#puts "=============#{i}============="
		new_version = versions[i-1]
		version = versions[i]
		version.build
		ncs, ccs, eccs, nccs, nmhcs = new_version.compare_constraints(version)
    # nmhcs => not matched html constraints with previous html/validate constraints
		if ncs.length > 0 or ccs.length > 0
			cnt += 1
		end

		model_ncs = ncs.select{|x| x.type == 'validate'}
		db_ncs = ncs.select{|x| x.type == "db"}
    html_ncs = ncs.select{|x| x.type == "html"}
		model_ccs = ccs.select{|x| x.type == 'validate'}
		db_ccs = ccs.select{|x| x.type == "db"}
    html_ccs = ccs.select{|x| x.type == "html"}
		c1 = model_ncs.length
		c2 = db_ncs.length
    ch1 = html_ncs.length
		c3 = model_ccs.length
		c4 = db_ccs.length
    ch2 = html_ccs.length
		model_eccs = eccs.select{|x| x.type == 'validate'}
		db_eccs = eccs.select{|x| x.type == "db"}
    html_eccs = eccs.select{|x| x.type == "html"}
		model_nccs = nccs.select{|x| x.type == 'validate'}
		db_nccs = nccs.select{|x| x.type == "db"}
    html_nccs = nccs.select{|x| x.type == "html"}
		c5 = model_eccs.length
		c6 = db_eccs.length
    ch3 = html_eccs.length
		c7 = model_nccs.length
		c8 = db_nccs.length
    ch4 = html_nccs.length
		sum1 += c1
		sum2 += c2
		sum3 += c3
		sum4 += c4
		sum5 += c5
		sum6 += c6
		sum7 += c7
		sum8 += c8
    sumh1 += ch1
    sumh2 += ch2
    sumh3 += ch3
    sumh4 += ch4
		versions[i-1] = nil
    output_html_constraints.write("======#{new_version.commit} vs #{version.commit}=====\n")
    nmhcs.each do |c|
      output_html_constraints.write(c.to_string)
      output_html_constraints.write("\n------------------\n")
    end
    output_html_constraints.write("=========================================\n")
	end
	output.write("#{versions.length} #{cnt} #{sum1} #{sum2} #{sum3} #{sum4} #{sum5} #{sum6} #{sum7} #{sum8} #{sumh1} #{sumh2} #{sumh3} #{sumh4}\n")
	output.close
  output_html_constraints.close
end
def find_all_mismatch(application_dir, interval)
	puts "interval: #{interval.class.name}"
	versions = extract_commits(application_dir, interval)
	return if versions.length <= 0
	for v in versions
		find_mismatch_oneversion(application_dir, v.commit)
	end
end
# in latest version
def find_mismatch_oneversion(directory, commit = "master")
	`cd #{directory}; git checkout #{commit}`
	version = Version_class.new(directory, commit)
	version.build
	version.compare_self
end