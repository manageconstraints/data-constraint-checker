apps = open('app_names.txt').readlines
apps = apps.map{|x| x.strip}
apps.each do |app|
  `cd formatchecker/constraint_analyzer; ruby main.rb /home/cc/apps/#{app}`
end
