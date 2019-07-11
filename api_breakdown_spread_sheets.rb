require 'rubygems'
require 'write_xlsx'



def write_to_sheet(worksheet, api_data, format)
	col = row = 0
	for row in 0...api_data.size
		contents = api_data[row]
		for col in 0..contents.size
			worksheet.write(row, col, contents[col], format)
		end
	end
end

def is_numeric(str)
	Float(str) != nil rescue false
end
# Create a new Excel workbook

workbook = WriteXLSX.new("output/api_total_breakdown.xlsx")

# Add a worksheet

app_names = open("app_names.txt").readlines.map{|x| x.strip}

# Add and define a format
format = workbook.add_format # Add a format
#format.set_bold
format.set_align('left')
apps_12_array = []
width = 0
length = 0
current_num = []
app_names.each do |app_name|
	worksheet = workbook.add_worksheet(app_name)
	array = []
	api_breakdown_file = "log/api_breakdown_#{app_name}.log"
	lines = open(api_breakdown_file).readlines.map{|x| x.strip}
	lines.each do |line|
		line_array = line.split(" ")
		array << line_array
		width = line_array.length if width < line_array.length
	end
	length = array.length if array.length > length
	apps_12_array << array
	write_to_sheet(worksheet, array, format)
end
final_summary = []
length.times.each do
	array = []
	width.times.each do
		array << 0
	end
	final_summary << array
end
for index in 0...apps_12_array.size
	array = apps_12_array[index]
	current_num << array[2][1..-1]
	for i in 0...length
		break if i > array.length
		for j in 0...width
			break if j > array[j].length
			cell = array[i][j]
			if is_numeric(cell)
				final_summary[i][j] += cell.to_i
			else
				final_summary[i][j] = cell
			end
		end
	end
end
worksheet = workbook.add_worksheet("summary")
write_to_sheet(worksheet, final_summary, format)

worksheet = workbook.add_worksheet("latest-version")
write_to_sheet(worksheet, current_num.transpose, format)

# Write a formatted and unformatted string, row and column notation.

workbook.close
