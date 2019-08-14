
def extract_commits(directory, interval=5, tag_unit=true)
	# reset to the most up to date commit
	puts "cd #{directory}; git checkout master"
	`cd #{directory}; git checkout master`
	tags = `cd #{directory}; git tag`
	if tag_unit
		commits = tags.lines.reverse.map{|x| x.strip}
	end
	if !commits || commits.length < 10
		commits = `python commits.py #{directory}`
		commits = commits.lines
		interval = 100
	else
		interval = 1
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
	puts "versions.length: #{versions.length}"
	return versions
end

def current_version_constraints_num(application_dir, commit="master")
	`cd #{application_dir}; git checkout #{commit}`
	version = Version_class.new(application_dir, commit)
	version.build
	version.column_stats
	puts "Latest Version Constraint Breakdown: #{version.total_constraints_num} #{version.db_constraints_num} #{version.model_constraints_num} #{version.html_constraints_num} columnstats: #{version.column_stats}"
end

def first_last_version_comparison_on_num(application_dir)
	`cd #{application_dir}; git stash; git checkout master`
	versions = extract_commits(application_dir, 1, false)
	if versions.length <= 0
		puts "No versions"
		return
	end
	version0 = versions[0]
	version1 = versions[-1]
	version0.build
	version1.build
	puts "Latest Version Constraint Breakdown: #{version0.total_constraints_num} #{version0.db_constraints_num} #{version0.model_constraints_num} #{version0.html_constraints_num}"
	puts "First Version Constraint Breakdown: #{version1.total_constraints_num} #{version1.db_constraints_num} #{version1.model_constraints_num} #{version1.html_constraints_num}"
end

def api_breakdown(application_dir)
	commit = "master"
	app_name = application_dir.split("/")[-1]
	output = open("../log/api_breakdown_#{app_name}.log", 'w')
	`cd #{application_dir}; git checkout -f #{commit}`
	version = Version_class.new(application_dir, commit)
	version.build
	db_constraints = version.getDbConstraints
	model_constraints = version.getModelConstraints
	html_constraints = version.getHtmlConstraints
	# get all types of constraints
	constraint_classes = Constraint.descendants
	db_dic = api_type_breakdown(db_constraints)
	model_dic = api_type_breakdown(model_constraints)
	html_dic = api_type_breakdown(html_constraints)
	# output the result to log file
	output.write("=======START BREAKDOWN of API\n")
	output.write("constraint_type #db #model #html\n")
	output.write("Layer_breakdown: #{version.total_constraints_num} #{version.db_constraints_num} #{version.model_constraints_num} #{version.html_constraints_num}\n"
)
	output.write("constraint_type #{version.total_constraints_num} #{db_constraints.size} #{model_constraints.size} #{html_constraints.size}\n")
	constraint_classes.each do |constraint_class|
		output.write("#{constraint_class} #{db_dic[constraint_class]} #{model_dic[constraint_class]} #{html_dic[constraint_class]}\n")
	end
	output.write("=======FINISH BREAKDOWN of API\n")
	output.close
end

def custom_error_msg_info(application_dir)
	commit = "master"
	`cd #{application_dir}; git checkout -f #{commit}`
	version = Version_class.new(application_dir, commit)
	version.build
	model_cons = version.getModelConstraints
	custom_error_msg_cons = model_cons.select{|c| c and c.custom_error_msg == true}
	built_in_cons = model_cons.select{|c| c and !(c.is_a? Customized_constraint or c.is_a? Function_constraint)}
	puts "============ CUSTOM ERROR MSG"
	puts "custom error msg count: #{custom_error_msg_cons.length}"
	puts "total model built-in count: #{built_in_cons.length}"
	puts "total model constraint count: #{model_cons.length}"
end

def api_type_breakdown(constraints)
	num_dic = {}
	constraint_classes = Constraint.descendants
	constraint_classes.each do |c|
		num_dic[c] = 0
	end
	if constraints
		constraints.each do |c|
			c_class = c.class
			if not num_dic[c_class]
				num_dic[c_class] = 1
			end
			num_dic[c_class] += 1
		end
	end
	return num_dic
end

def total_number_comparison(application_dir, commit="master")
	`cd #{application_dir}; git checkout -f #{commit}`
	version = Version_class.new(application_dir, commit)
	version.build
	puts "Latest Version Constraint Breakdown: #{version.total_constraints_num} #{version.db_constraints_num} #{version.model_constraints_num} #{version.html_constraints_num}"
end

def traverse_constraints_code_curve(application_dir, interval, tag_unit=true)
  versions = extract_commits(application_dir, interval, tag_unit)
  puts "versions.length: #{versions.length}"
  return if versions.length <= 0
  app_name = application_dir.split("/")[-1]
  output = open("../log/output_loc_constraints_#{app_name}.log", 'w')
  for i in 0...versions.length
    version = versions[i]
    version.build
    content = "#{version.loc} #{version.total_constraints_num} #{version.db_constraints_num} #{version.model_constraints_num} #{version.html_constraints_num}\n"
    output.write(content)
  end
  output.close
end

def traverse_all_versions(application_dir, interval, tag_unit=true)
	versions = extract_commits(application_dir, interval, tag_unit)
	puts "versions.length: #{versions.length}"
	return if versions.length <= 0
	app_name = application_dir.split("/")[-1]
	versions[0].build
	output = open("../log/output_#{app_name}.log", 'w')
  output_diff_codechange = open("../log/codechange_#{app_name}.log", "w")
  log_dir = "../log/#{app_name}_log/"
  if not File.exist?log_dir
    `mkdir #{log_dir}`
  end
  output_html_constraints = open("#{log_dir}/html_constraints.log", 'w')
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
	count1 = count2 = count3 = count4 = count5 = count6 = count7 = count8 = counth1 = counth2 = counth3 = counth4 = 0
  start = Time.now
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
		file, insertion, deletion = code_change(application_dir, new_version.commit, version.commit)
		model_ncs = ncs.select{|x| x.type == Constraint::MODEL}
		db_ncs = ncs.select{|x| x.type == Constraint::DB}
    html_ncs = ncs.select{|x| x.type == Constraint::HTML}
		model_ccs = ccs.select{|x| x.type == Constraint::MODEL}
		db_ccs = ccs.select{|x| x.type == Constraint::DB}
    html_ccs = ccs.select{|x| x.type == Constraint::HTML}
		c1 = model_ncs.length
		c2 = db_ncs.length
    ch1 = html_ncs.length
		c3 = model_ccs.length
		c4 = db_ccs.length
    ch2 = html_ccs.length
		model_eccs = eccs.select{|x| x.type == Constraint::MODEL}
		db_eccs = eccs.select{|x| x.type == Constraint::DB}
    html_eccs = eccs.select{|x| x.type == Constraint::HTML}
		model_nccs = nccs.select{|x| x.type == Constraint::MODEL}
		db_nccs = nccs.select{|x| x.type == Constraint::DB}
    html_nccs = nccs.select{|x| x.type == Constraint::HTML}
		c5 = model_eccs.length
		c6 = db_eccs.length
    ch3 = html_eccs.length
		c7 = model_nccs.length
		c8 = db_nccs.length
    ch4 = html_nccs.length
		sum1 += c1 # model ncs
		sum2 += c2 # db ncs
		sum3 += c3 # model ccs
		sum4 += c4 # db ccs
		sum5 += c5 # model eccs
		sum6 += c6 # db eccs
		sum7 += c7 # model nccs
		sum8 += c8 # db nccs
    sumh1 += ch1 # html ncs
    sumh2 += ch2 # html ccs
    sumh3 += ch3 # html eccs
    sumh4 += ch4 # html nccs
		count1 += 1 if c1 > 0
		count2 += 1 if c2 > 0
		count3 += 1 if c3 > 0
		count4 += 1 if c4 > 0
		count5 += 1 if c5 > 0
		count6 += 1 if c6 > 0
		count7 += 1 if c7 > 0
		count8 += 1 if c8 > 0
		counth1 += 1 if ch1 > 0
		counth2 += 1 if ch2 > 0
		counth3 += 1 if ch3 > 0
		counth4 += 1 if ch4 > 0
    output_diff_codechange.write("#{file} #{insertion} #{deletion} #{c1} #{c2} #{c3} #{c4} #{c5} #{c6} #{c7} #{c8} #{ch1} #{ch2} #{ch3} #{ch4}\n")
		versions[i-1] = nil
    output_html_constraints.write("======#{new_version.commit} vs #{version.commit}=====\n")
    nmhcs.each do |c|
      output_html_constraints.write(c.to_string)
      output_html_constraints.write("\n------------------\n")
    end
    output_html_constraints.write("=========================================\n")
    puts "Duration: #{Time.now - start}"
    start = Time.now
	end
	output.write("#{versions.length} #{cnt} #{sum1} #{sum2} #{sum3} #{sum4} #{sum5} #{sum6} #{sum7} #{sum8} #{sumh1} #{sumh2} #{sumh3} #{sumh4}\n")
	output.write("VERSION number #{count1} #{count2} #{count3} #{count4} #{count5} #{count6} #{count7} #{count8} #{counth1} #{counth2} #{counth3} #{counth4}\n")
	output.close
  output_diff_codechange.close
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
