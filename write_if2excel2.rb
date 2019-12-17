require 'rubygems'
require 'write_xlsx'

# Create a new Excel workbook
def write_to_sheet(worksheet, api_data, format)
	col = row = 0
	# puts "api_data #{api_data.size}"
	for row in 0...api_data.size
		contents = api_data[row]
		# puts "contents : #{contents.size}"
		for col in 0..2
			# puts "contents[col #{contents[col]}"
			worksheet.write(row, col, contents[col], format)
		end
	end
end


output = "ifcheck"
workbook = WriteXLSX.new("output/#{output}.xlsx")

app_names = open("app_names.txt").readlines.map{|x| x.strip}

# Add and define a format
format = workbook.add_format # Add a format
#format.set_bold
format.set_align('left')
width = 0
length = 0
current_num = []
#app_names.each do |app_name|
	worksheet = workbook.add_worksheet("ifchecking")
	array = []
	validation_file = "log/ifcheck.txt"
	c = open(validation_file).readlines
	indices = c.each_index.select{|k| c[k].include?"===========================\n"}
	funcs = []
	indices.length.times.each do |index|
		startIndex = indices[index] + 1
		if (index >= indices.length - 1)
			endIndex = -1
		else
			endIndex = indices[index+1]
		end
		puts "#{startIndex} #{endIndex}"
		code = c[startIndex+1...endIndex].join("")
		filename = c[startIndex]
		if not funcs.include?code
			array << [filename, code]
		end 
		funcs << code
		
	end
	write_to_sheet(worksheet, array, format)
#end


# Write a formatted and unformatted string, row and column notation.

workbook.close