input = ARGV[0]
output = ARGV[1]
input_file = open(input)
contents = input_file.read
input_file.close
write_contents = ""
contents.lines.each do |line|
  if line.strip.end_with?(",")
    write_contents += line.gsub("\n", "")
  else
    write_contents += line
  end
end
output_file = open(output, "w")
output_file.write(write_contents)
output_file.close
