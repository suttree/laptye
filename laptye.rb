#! /usr/bin/ruby

require 'nokogiri'
require 'open-uri'

i = 0
url = 'http://uk.linkedin.com/in/peterhgough'

begin
  i += 1

  doc = Nokogiri::HTML(open(url))

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

  puts "Finding someone else"
  links = []
  doc.css('.browsemap .content li a').each do |link|
    links << link['href']
  end
  url = links.sample(1).first

  puts "This one"
  puts url.inspect
end while i < 5

# Todo
#
# store job titles
# browse randomly by picking profiles from the "viewers also viewed" sidebar
# run continually
