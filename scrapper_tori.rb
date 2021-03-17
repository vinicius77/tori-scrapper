require "nokogiri"
require "httparty"

class ToriScrapper
	attr_accessor :page
	attr_reader :item
	def initialize(item)
		@item = item
		@page = 1
	end

	def get_results

		url = url_creator(@item, @page)

		parsed_page = page_scrapper(url)

		
		# HTML element where all products are placed 
		# (for some reason they are all inside of an anchor tag)
		products = parsed_page.css('a.item_row_flex') 

		# total number of products per page
		products_per_page = products.count

		# Grabs the element where the total number of pages is located on Tori's page 
		# and converts it to a number
		total_products = parse_element_to_number(parsed_page.css("div.boxes_selected_item").children.text)

		# calculates the very last page in the website	
		last_page = last_page_calculator(total_products, products_per_page)

		# will store every product
		productsArr = Array.new

		puts "Loading all products, it may take a while. :)"
		puts ""

		while @page <= last_page
			puts loading_message(percentage_calculator(@page, last_page))
			# creates a new url with a given page
			paginated_url = url_creator(@item, @page)
			# Makes a GET request based in the new url created previously and parses the page
			paginated_parsed_page = page_scrapper(paginated_url)
			# all the products are placed inside of this anchor tag
			paginated_products_list = paginated_parsed_page.css('a.item_row_flex')	

			paginated_products_list.each do |item|
				# creates a new object in each interaction
				# and pushes it to the products array
				productsArr << object_creator(item)
			end

			@page +=1
		end

		puts ""
		puts "Loading Completed. Thanks for your patience :)"
		puts ""

		puts productsArr.first
		puts productsArr.last
		
	end
	
	private
	# creates the url to feed the scrapper
	def url_creator(item, page_number)
		"https://www.tori.fi/uusimaa?ca=18&q=#{item}&w=1&o=#{page_number}"
	end

	# makes a GET request to the url (HTTParty) return the result
	# takes the result and converts it to HTML (Nokogiri) 
	def page_scrapper(url)
		response = HTTParty.get(url)
		Nokogiri::HTML(response.body)
	end

	def parse_element_to_number(element)
		/[0-9]+\s[0-9]+/.match(element)[0].gsub(" ", "").to_i
	end

	def last_page_calculator(total, per_page)
		(total.to_f / per_page.to_f).ceil
	end

	def object_creator(item)
		product = {
				title: item.css("div.li-title").text,
				published_at: date_formatter(item.css("div.date_image")),
				link: item.attributes["href"].value,
		}
		product
	end

	def date_formatter(element)
		element.text.gsub(/\s+/, "")
	end

	def percentage_calculator(page, last_page)
		(@page * 100) / last_page
	end

	def loading_message(percentage)			
		"Loading products | #{percentage}%"
	end
end

tori_scrapper = ToriScrapper.new("annetaan")
tori_scrapper.get_results