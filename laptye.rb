#! /usr/bin/ruby

require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('http://uk.linkedin.com/in/peterhgough'))

puts "Current"
puts "======="
doc.css('.current li').each do |current|
  current.css('.at').remove
  current.css('.company-profile-public').remove
  puts current.text.strip
end

puts "Past"
puts "===="
doc.css('.past li').each do |past|
  past.css('.at').remove
  past.css('.company-profile-public').remove
  puts past.text.strip
end
