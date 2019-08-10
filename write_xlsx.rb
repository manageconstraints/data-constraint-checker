require 'rubygems'
require 'write_xlsx'

# Create a new Excel workbook

output = ARGV[1] || "output"
workbook = WriteXLSX.new("output/#{output}.xlsx")

# Add a worksheet
worksheet = workbook.add_worksheet
grep_param = ARGV[0] || "mismatch_constraint"
lines = `grep "#{grep_param}" log/output.log`
lines = lines.lines
lines = lines.map{|x| x.strip}

# Add and define a format
format = workbook.add_format # Add a format
#format.set_bold
format.set_align('left')

# Write a formatted and unformatted string, row and column notation.
col = row = 0
for row in 0...lines.length
	line = lines[row]
	contents = line.split("\t")
	for col in 0..contents.length
		worksheet.write(row, col, contents[col], format)
	end
end
workbook.close
