apps = open('app_names.txt').readlines
apps = apps.map{|x| x.strip}
main_folder = ARGV[0] || 'constraint_analyzer'
app_folder = ARGV[1]
return unless app_folder
apps.each do |app|
	`cd #{main_folder}; ruby main.rb #{app_folder}/#{app}`
	# lines = open("./log/output_#{app}.log").readlines
	# data = lines[-1].strip.split(" ")
end

