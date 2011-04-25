#! /usr/bin/env ruby

require 'optparse'

options = {}

optparse = OptionParser.new do|opts|
  opts.banner = "Usage: resource_gen.rb [options] file1.csv ..."
  opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
   end

end

optparse.parse!


filename = ARGV[0]
type = filename.to_s.split(".").first
contents = []

file = File.open("#{filename}","r")

file.each do |line|
  contents << line
end

file.close

data = Hash.new

# get a list of paramaters that will be assigned
# the first one should *always* be the titlevar
keys = contents.shift.split(",")
longest = ""
keys.each do |k|
  k.chomp
  longest = k if k.length > longest.length
end

contents.each do |v|
  index = 0
  v.chomp if v.class == String

  params = v.split(",")
  # create the data structure per record
  params.each do |param|
    data["#{keys[index].chomp}"] = param.chomp
    index = index + 1
  end

  # do the output thing
  index = 0
  params.each do |param|
    spacediff = longest.length - keys[index].chomp.length
    myval = data[keys[index].chomp]
    spaces = " " * spacediff if spacediff > 0
    puts "#{type} { '#{data[keys[0]]}':" if index == 0
    
    if myval != ""
      puts "  #{keys[index].chomp} #{spaces}=> '#{myval}'," if index > 0 
    end
    
    index = index + 1
    puts "}" if index == params.size
    puts "" if index == params.size
  end
end


