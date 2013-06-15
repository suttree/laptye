#! /usr/bin/ruby

require 'mysql2'
require 'nokogiri'
require 'open-uri'

#mysql> create table jobs (
#       id INT primary key NOT NULL AUTO_INCREMENT,
#       title text,
#       next_job_id int,
#       previous_job_id int
#       );

i = 0
url = 'http://uk.linkedin.com/in/peterhgough'
client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :database => 'laptye')

begin
  i += 1

  doc = Nokogiri::HTML(open(url))
  next_job_id = nil

  puts "Current"
  puts "======="
  doc.css('.current li').each do |current|
    current.css('.at').remove
    current.css('.company-profile-public').remove
    title = current.text.strip.split(/\n/).first
    puts title

    client.query("INSERT INTO jobs (title) VALUES ('#{title}')")
    result = client.query("SELECT LAST_INSERT_ID() AS next_id;")
    next_job_id = result.first['next_id']
  end

  puts "Past"
  puts "===="
  doc.css('.past li').each do |past|
    past.css('.at').remove
    past.css('.company-profile-public').remove
    title = past.text.strip.split(/\n/).first
    #puts title

    client.query("INSERT INTO jobs (title, next_job_id) VALUES ('#{title}', #{next_job_id})")

    result = client.query("SELECT LAST_INSERT_ID() AS next_id;")
    next_job_id = result.first['next_id']
  end

  puts "Finding someone else"
  links = []
  doc.css('.browsemap .content li a').each do |link|
    links << link['href']
  end
  url = links.sample(1).first

  puts "This one"
  puts url.inspect
end while i < 500
