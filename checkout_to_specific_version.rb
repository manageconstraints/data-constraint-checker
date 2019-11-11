apps = open("app_with_commit.txt").readlines.map{|x| x.strip.split("\t")}
apps.each do |app, commit|
  `cd apps/#{app}; git checkout #{commit}`
end
