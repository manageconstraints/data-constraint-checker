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


output = "validationfunctions"
workbook = WriteXLSX.new("output/#{output}.xlsx")

app_names = open("app_names.txt").readlines.map{|x| x.strip}

# Add and define a format
format = workbook.add_format # Add a format
#format.set_bold
format.set_align('left')
width = 0
length = 0
current_num = []
app_names.each do |app_name|
	worksheet = workbook.add_worksheet(app_name)
	array = []
	validation_file = "log/validation_functions#{app_name}.log"
	c = open(validation_file).readlines.map{|x| x.strip}
	indices = c.each_index.select{|k| c[k].include?"====start of function"}
	funcs = []
	indices.length.times.each do |index|
		startIndex = indices[index]
		if (index + 1 < indices.length)
			endIndex = indices[index+1] - 1
		else
			endIndex = -1
		end
		filename = c[startIndex+1].gsub("in file: ","")
		code = c[startIndex+2...endIndex].join("\n")
		puts "filename: #{filename} \n#{code}"
		if not funcs.include?code
			array << [filename, code]
		end 
		funcs << code
		
	end
	write_to_sheet(worksheet, array, format)
end


# Write a formatted and unformatted string, row and column notation.

workbook.close