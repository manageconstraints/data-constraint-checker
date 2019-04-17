input = ARGV[0]
output = ARGV[1]
contents = open(input).read
write_contents = ""
contents.lines.each do |line|
  if line.strip.end_with?(",")
    write_contents += line.gsub("\n",'')
  else
    write_contents += line
  end
end
open(output, 'w').write(write_contents)