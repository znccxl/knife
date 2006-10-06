#!/usr/bin/env ruby
# unit test runner

bar = ""
failed = Array.new
Dir['*_test.rb'].each do |test|
 if system(File.expand_path(test))
  bar += "G"
 else
  bar += "R"
  failed << test
 end 
end

puts

puts bar

if failed.empty?
 puts "All tests passed." 
 exit 0
else
 puts "Failed tests:" 
 puts failed
 exit 1
end

