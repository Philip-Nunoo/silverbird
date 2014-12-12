require 'silverbird/version'
require 'open-uri'
require 'nokogiri'

module Silverbird
# Your code goes here...

	def self.movies_in city  	
		movies = Array.new
		url = "http://silverbirdcinemas.com/#{city.to_s.downcase}"

		doc = Nokogiri::HTML(open(url))
		doc.css(".catItemIsFeatured").each do |item|
			# puts "here"
			movie = Movie.new
			title = item.at_css(".catItemTitle a").text
			running_time = item.at_css('.catItemExtraFieldsValue').text
			image_url = nil

			intro_text = nil

			if item.at_css('.catItemIntroText p')!=nil 
				intro_text = item.at_css('.catItemIntroText p').text
				movie.intro_text = intro_text.strip
			end

			if(item.at_css('.catItemImageBlock img') != nil)
				image_url = item.at_css('.catItemImageBlock img')[:src]
			end
			movie.title = title.strip
			movie.time = running_time.strip
			movie.image_url = "http://silverbirdcinemas.com/#{image_url}"

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
