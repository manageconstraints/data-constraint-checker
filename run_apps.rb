apps = open('app_names.txt').readlines
apps = apps.map{|x| x.strip}
main_folder = 'constraint_analyzer'
app_folder = '../apps'
command = ARGV[0] || "-s"
return unless app_folder
count = {}
log = open("log/output.log",'w')
apps.each do |app|
	if app.start_with?'#'
		next
	end
	execute = "cd #{main_folder}; ruby main.rb -a #{app_folder}/#{app} #{command}"
	puts "#{execute}"
	lines = `#{execute}`
	log.write("======#{app}======\n")
	log.write(lines)
	log.write("\n")

	lines = lines.lines
	absent_total = lines[-1].strip
	count[app] = absent_total
	#puts "#{app} #{absent_total}"
	# `cd #{main_folder}; ruby main.rb #{app_folder}/#{app}`
	# lines = open("./log/output_#{app}.log").readlines
	# data = lines[-1].strip.split(" ")
end
log.close
count.each do |k, v|
	puts "#{k} #{v.gsub("total absent: ", "")}"
end
