apps = open('app_names.txt').readlines
apps = apps.map{|x| x.strip}
main_folder = ARGV[0] || 'constraint_analyzer'
app_folder = ARGV[1]
return unless app_folder
apps.each do |app|
	lines = `cd #{main_folder}; ruby main.rb -a #{app_folder}/#{app} -s`
	lines = lines.lines
	absent_total = lines.find{|x| x.include?'absent total: '}
	puts "#{app} #{absent_total}"
	# `cd #{main_folder}; ruby main.rb #{app_folder}/#{app}`
	# lines = open("./log/output_#{app}.log").readlines
	# data = lines[-1].strip.split(" ")
end

