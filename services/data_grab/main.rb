#!/usr/bin/ruby
# main script for pulling catalog data from multiple providers

require 'rubygems' 
require 'bundler/setup' 

require 'rest_client'
require 'active_record'
require 'logger'
require 'optparse'
require 'yaml'
require 'byebug'
require_relative 'providers'
require_relative 'coursera_helper_methods'
require_relative 'provider-codeschool'
require_relative 'provider-treehouse'

class Product < ActiveRecord::Base
end

# it maps providers according to the value in vendors table
providers = [
	{ vendor_id: 1, provider_class: CourseraClient, price: nil },
	{ vendor_id: 2, provider_class: YoutubeClient, price: 0 },
	{ vendor_id: 9, provider_class: JsonClient, price: 49 }, # GA
	#{ vendor_id: 14, provider_class: JsonClient, price: 25 }, # Treehouse via Import.IO/JSON 
	{ vendor_id: 14, provider_class: TreehouseClient, price: 25 }, # Treehouse via Nokogiri
	{ vendor_id: 10, provider_class: JsonClient, price: nil }, # edX 
	#{ vendor_id: 11, provider_class: JsonClient, price: 29 }, # Code School via Import.IO/JSON 
	{ vendor_id: 11, provider_class: CodeSchoolClient, price: 29 }, # Code School via Nokogiri
	{ vendor_id: 6, provider_class: JsonClient, price: 25 }, # Lynda 
	{ vendor_id: 3, provider_class: UdemyClient, price: nil } # Udemy
]

options = {:config => nil}
OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on('-c', '--config config', 'Config file (required)') do |config|
    options[:config] = config
  end

  opts.on('-p', '--provider provider', 'Provider of data (required)') do |provider|
    options[:provider] = provider
  end

  opts.on('-j', '--json input_file', 'Input File in JSON format') do |json|
    options[:json] = json
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end.parse!

if options[:config].nil? || options[:provider].nil?
    puts 'Missing arguments. Use -h for help'
    exit
end

config = YAML.load_file(options[:config])

# Establish our DB connection 
ActiveRecord::Base.establish_connection\
	:adapter => config['database']['adapter'],\
	:database => config['database']['database'],\
	:host => config['database']['host'],\
	:port => config['database']['port'],\
	:username => config['database']['username'],\
	:password => config['database']['password']


# get the right provider class and create its instance
provider = nil
for p in providers
	if p[:vendor_id] == options[:provider].to_i
		provider = p[:provider_class].new(p[:vendor_id], options[:json], p[:price])
		break
	end
end

instructors_json = provider.instructors
courses_json = provider.courses
skipped = 0

courses_json.each_with_index do |crs, i|

	# construct the course url and then search existing record in the DB
	course_url = provider.origin(crs)
	existing_prd = Product.find_by_origin(course_url)
	if existing_prd.nil?
		prd = Product.new
		prd.vendor_id = provider.vendor_id
		prd.name = provider.name(crs) 
		prd.description = provider.description(crs)
		prd.price = provider.price(crs)
		prd.authors = provider.authors(crs)
		prd.duration = provider.duration(crs)

		# in some cases, instructors field may be empty, then we need to dig into the assicoated links
		if prd.authors.blank?
			#puts "blank instr, linked instructors=" + crs['links']['instructors'].to_s
			if !crs['links'].blank? && !crs['links']['instructors'].blank?
				# find instructors in the pre-fetched list
				crs['links']['instructors'].each { |linked_instructor|
					instructors_json.each { |instr|
						if instr['id'] == linked_instructor
							#puts "linked instructor " + instr['firstName'] + ' ' + instr['lastName']
							if prd.authors.blank?
								prd.authors = instr['firstName'] + ' ' + instr['lastName']
							else
								prd.authors += ', ' + instr['firstName'] + ' ' + instr['lastName']
							end
						end
					}
				}
			end
		end
		prd.school = provider.school(crs)
		prd.origin = course_url
		prd.media_type = 'online'
		prd.manual_entry = false
		prd.save
	else 
		skipped += 1
	end
	if (i % 100) == 0 then print '.' end
end



print "\n"
puts('Processed ' + courses_json.length.to_s + ' records, ' + skipped.to_s + ' skipped ')