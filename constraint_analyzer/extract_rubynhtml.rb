def readChar(f)
  if (f.eof?)
    exit
  end
  char = f.readchar
  return char
end

def newLine
  $line += 1
  $offset = 0
end

input_file = ARGV[0]
output_file = ARGV[1]
$id = 0
line_file = output_file + ".line"
tag_file = output_file + ".tag"
#if File.exist?output_file
$fout = File.open(output_file, "w+")
string_buffer = ""
tags = []
end_tag = ""
start_ruby = 0
start_tag = 0
$line = 1
isDisplay = 0
ruby_buffer = ""
$cl = 1
write_buffer = ""
single_tag = ["br", "br/", "img", "html", "head", "title", "meta", "link", "script", "hr", "hr/"]
$offset = 0
start_offset = 0
start_line = 0
tagout_hash = {}
if !File.exists? input_file
  exit
end
File.open(input_file, "r") do |f|
  a = readChar(f)
  $offset += 1
  newLine if a == "\n"
  b = readChar(f)
  c = readChar(f)
  while (!f.eof? or (b == "%" and c == ">") or (a == "-" and b == "%" and c == ">"))
    if (a == "<" and b =~ /[A-Za-z]/) and start_ruby == 0
      start_offset = $offset
      start_line = $line
      string_buffer = a + b + c
      a = b
      b = c
      c = readChar(f)
      $offset += 1
      #puts"1: $offset : #{$line}_#{$offset}"
      newLine if a == "\n"
      string_buffer += c
      start_tag = 1
    elsif b != "%" and b != "=" and c == ">" and start_ruby == 0 and start_tag == 1
      ##puts"string_buffer #{string_buffer}"
      tag = string_buffer.split(" ")[0].gsub("<", "").gsub(">", "")
      match_id = string_buffer.match(/\sid\s*=\s*['"][^'"]*['"]/)
      id = ""
      if match_id
        id = match_id[0].split("=")[1].gsub("\"", "").gsub("'", "")
      end
      if !single_tag.include? tag
        tags << [tag, id]
        tagout_hash["#{tag}##{id}"] = [start_line, start_offset]
      end
      a = b
      b = c
      c = readChar(f)
      $offset += 1
      newLine if a == "\n"
      write_buffer = write_buffer.gsub("remainToWrite", tags.map { |t| "#{t[0]}##{t[1]}" }.join(" "))
      write_buffer = ""
      start_tag = 0
      string_buffer = ""
    elsif (a == "<" and b == "/") and start_ruby == 0
      end_tag += c
      a = b
      b = c
      c = readChar(f)
      $offset += 1
      newLine if a == "\n"

      while (c != ">")
        end_tag += c
        a = b
        b = c
        c = readChar(f)
        $offset += 1
        newLine if a == "\n"
      end
      if tags and tags.length > 0
        tag_name = "#{tags[-1][0]}##{tags[-1][1]}"
        tagout_hash[tag_name] += [$line, $offset + 2]
        tags.pop
        end_tag = ""
      end
    elsif (a == "<" and b == "%")
      start_ruby = 1
      if (c == "=" or c == "-")
        a = readChar(f)
        b = readChar(f)
        c = readChar(f)
        $offset += 3
        ruby_buffer = a + b + c
        string_buffer += a + b + c if start_tag == 1
        isDisplay = 1
        if (a == "\n")
          if (start_tag == 1)
            write_buffer += "#{$line}\t#{isDisplay}\tremainToWrite\n"
          else
            result = "#{$line}\t#{isDisplay}\t#{tags[-1] ? tags.map { |t| "#{t[0]}##{t[1]}" }.join(" ") : "null"}\n"
          end
          $cl += 1
          newLine
        end
        $fout.write(a)
      elsif (c == "#")
        a = b
        b = c
        c = readChar(f)
        $offset += 1
        newLine if a == "\n"
        string_buffer += c
      else
        if (c == "\n")
          if (start_tag == 1)
            write_buffer += "#{$line}\t#{isDisplay}\tremainToWrite\n"
          else
            result = "#{$line}\t#{isDisplay}\t#{tags[-1] ? tags.map { |t| "#{t[0]}##{t[1]}" }.join(" ") : "null"}\n"
          end
          newLine
          $cl += 1
          $fout.write(c)
        end

        isDisplay = 0
        a = readChar(f)
        b = readChar(f)
        c = readChar(f)
        $offset += 3
        string_buffer += a + b + c if start_tag == 1
        ruby_buffer += a + b + c
        if (a == "\n")
          if (start_tag == 1)
            write_buffer += "#{$line}\t#{isDisplay}\tremainToWrite\n"
          else
            result = "#{$line}\t#{isDisplay}\t#{tags[-1] ? tags.map { |t| "#{t[0]}##{t[1]}" }.join(" ") : "null"}\n"
          end
          newLine
          $cl += 1
        end
        $fout.write(a)
      end
    elsif ((b == "%" and c == ">") or (a == "-" and b == "%" and c == ">"))
      $fout.write("\n")
      start_ruby = 0
      ruby_buffer = ""
      if (start_tag == 1)
        write_buffer += "#{$line}\t#{isDisplay}\tremainToWrite\n"
      end
      b = c
      c = readChar(f)

      $offset += 1
      if start_tag == 1
        string_buffer += c
      end
      $cl += 1
      newLine if a == "\n"
    else
      a = b
      b = c
      c = readChar(f)

      $offset += 1
      string_buffer += c if start_tag == 1
      ruby_buffer += c if start_ruby == 1
      if (start_ruby == 1)
        if (a == "\n")
          if (start_tag == 1)
            write_buffer += "#{$line}\t#{isDisplay}\tremainToWrite\n"
          else
            result = "#{$line}\t#{isDisplay}\t#{tags[-1] ? tags.map { |t| "#{t[0]}##{t[1]}" }.join(" ") : "null"}\n"
          end
          newLine
          $cl += 1
        end
        $fout.write(a) if !(a == "-" and b == "%" and c == ">")
      else
        newLine if (a == "\n")
      end
    end
  end
end
$fout.close
#end
