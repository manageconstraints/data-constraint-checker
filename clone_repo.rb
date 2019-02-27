apps = open("repo.txt").readlines.map{|x| x.strip}
`rm -rf apps/;mkdir apps`
apps.each do |app|
  `cd apps; git clone #{app}`
end 
