if content.nil?
	refetch(page["gid"])
else
	html = Nokogiri.HTML(content)
	product_details = page["vars"]["product_details"]


	product_details["_collection"] = "products"
	product_details["_id"] = product_details["competitor_product_id"]
	product_details["scraped_at_timestamp"] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
	product_details["category_id"] = nil
	product_details["category"] = html.at_css("#tab > ul > li > a.active > span").text.strip
	product_details["description"] = html.at_css("#descriptionsTab > .tabBody").text.strip rescue nil


	outputs << product_details
end