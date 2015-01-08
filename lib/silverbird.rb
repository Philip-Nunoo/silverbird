require 'silverbird/version'
require 'open-uri'
require 'nokogiri'

module Silverbird
# Your code goes here...
def self.theatres cinema
	theatres = Array.new

	if cinema.downcase.to_sym.eql? :silverbird
		# .moduletable_content #k2ModuleBox131 ul li
		url = "http://silverbirdcinemas.com"

		doc = Nokogiri::HTML(open(url))
		doc.css(".moduletable_content #k2ModuleBox131 ul li").each do |item|
			theatre = Theatre.new

			theatre_name = item.at_css('.catTitle').text
			theatre_link = item.at_css("a")[:href]

			theatre.name = theatre_name
			theatre.url = "http://silverbirdcinemas.com/#{theatre_link}"
			theatre.location = theatre_link

			theatres.push theatre
		end
	else
	end

	return theatres

end

def self.movies_in city  	
	movies = Array.new
	url = "http://silverbirdcinemas.com/#{city.to_s.downcase}"

	doc = Nokogiri::HTML(open(url))
	doc.css(".catItemIsFeatured").each do |item|
			# puts "here"
			movie = Movie.new
			title = item.at_css(".catItemTitle a").text
			running_time = item.at_css('.catItemExtraFieldsValue').text
			image_url = "http://cdn.ghanaweb.com/imagelib/pics/65028362.jpg"

			intro_text = "No description available"
			movie.intro_text = intro_text

			if item.at_css('.catItemIntroText p')!=nil 
				intro_text = item.at_css('.catItemIntroText p').text
				movie.intro_text = intro_text.strip
			end

			movie.image_url = image_url
			if(item.at_css('.catItemImageBlock img') != nil)
				image_url = item.at_css('.catItemImageBlock img')[:src]
				movie.image_url = "http://silverbirdcinemas.com/#{image_url}"
			end
			movie.title = title.strip
			movie.time = running_time.strip

			# movie.title item.at_css(".catItemTitle a").text
			movies.push movie
		end

		return movies
	end

	def self.cities
		# return cities
	end
end

class City
	def initialize(name)
		@name = name
	end
end

class Theatre
	@@array = Array.new
	attr_accessor :name, :url, :location

	def self.all_instances
		@@array
	end

	def print
		puts "Title: #{@name}"
		puts "Time : #{@url}"
	end
end

class Movie 
	@@array = Array.new
	attr_accessor :title, :time, :image_url, :intro_text

	def self.all_instances
		@@array
	end

	def print
		puts "Title: #{@title}"
		puts "Time : #{@time}"
		puts "Img  : #{@image_url}"
		puts "Intro: #{@intro_text}"
	end
end
