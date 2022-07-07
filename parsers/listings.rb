#require './lib/headers'
require './lib/helpers'

json = JSON.parse(content)


current_page = page["vars"]["page_number"]

total_page = json["data"]["pageInfo"]["pageCount"]

if current_page == 1 && total_page > 1

	(2..total_page).each do |pn|
		body = page["body"].gsub('"pageNum":1', "\"pageNum\":#{pn}")

		pages << {
			page_type: "listings",
			url: page["url"],
			method: "POST",
            body: body,
			headers: page["vars"]["headers"],
			vars: page["vars"].merge("page_number" => pn),
		}
	end
end



products = json["data"]["wareList"]

products.each_with_index do |product, idx|
	rank = idx + 1
	product_id = product["wareId"]
	product_name = product["wareName"]

	customer_price_lc = product["onlinePromotionPrice"]
	base_price_lc = product["onlinePrice"]
	has_discount = customer_price_lc < base_price_lc
	discount_percentage = has_discount ? GetFunc::get_discount(base_price_lc, customer_price_lc) : nil

	product_pieces = GetFunc::get_pieces(product_name)

	uom = GetFunc::get_uom(product_name)
	size_std = uom["size"]
	size_unit_std = uom["unit"]

	item_identifiers = JSON.generate({
		"barcode" => "'#{product_id}'"
	})

	outputs << {
		_collection: "product_list",
        _id: product_id,
        competitor_name: "WELLCOME",
        competitor_type: "dmart",
        store_name: page["vars"]["store_name"],
        store_id: page["vars"]["store_id"],
        country_iso: "HK",
        language: "ENG",
        currency_code_lc: "HKD",
        scraped_at_timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
        ###
        competitor_product_id: product_id,
        name: product_name,
        brand: nil,
        category_id: page["vars"]["category_id"],
        category: page["vars"]["category_name"],
        sub_category: nil,
        customer_price_lc: customer_price_lc,
        base_price_lc: base_price_lc,
        has_discount: has_discount,
        discount_percentage: discount_percentage,
        rank_in_listing: rank,
        page_number: current_page,
        product_pieces: product_pieces,
        size_std: size_std,
        size_unit_std: size_unit_std,
        description: nil,
        img_url: nil,
        barcode: product_id,
        sku: product["skuId"],
        url: nil,
        is_available: 1,
        crawled_source: "APP",
        is_promoted: false,
        type_of_promotion: nil, #type_of_promotion,
        promo_attributes: nil, #promo_attributes,
        is_private_label: nil, #is_private_label,
        latitude: nil,
        longitude: nil,
        reviews: nil, #reviews,
        store_reviews: nil, #store_reviews,
        item_attributes: nil,
        item_identifiers: item_identifiers,
        country_of_origin: nil,
        variants: nil,
        #uom: uom,
	}
end


#######



products = json["products"]

products.each_with_index do |product, idx|
	rank = idx + 1
	product_id = product["code"]

	product_brand = product["brandName"]


	customer_price_lc = nil
	base_price_lc = nil
	product["priceList"].each do |price|
		if price["priceType"] == "DISCOUNT"
			customer_price_lc = price["value"].to_f.round(2)
		elsif price["priceType"] == "BUY"
			base_price_lc = price["value"].to_f.round(2)
		end
	end
	customer_price_lc = customer_price_lc ? customer_price_lc : base_price_lc

	has_discount = customer_price_lc < base_price_lc
	discount_percentage = has_discount ? (((base_price_lc - customer_price_lc) / base_price_lc) * 100).round(7) : nil

	uom = product["packingSpec"]
	uom_regex = [
        /(?<![^\s])(\d*[\.,]?\d+)\s?(litre[s]?)(?![^\s])/i,
        /(?<![^\s])(\d*[\.,]?\d+)\s?(fl oz)(?![^\s])/i,
        /(?<![^\s])(\d*[\.,]?\d+)\s?([mcf]?l)(?![^\s])/i,
        /(?<![^\s])(\d*[\.,]?\d+)\s?([mk]?g)(?![^\s])/i,
        /(?<![^\s])(\d*[\.,]?\d+)\s?([mc]?m)(?![^\s])/i,
        /(?<![^\s])(\d*[\.,]?\d+)\s?(oz)(?![^\s])/i,
    ]
    uom_regex.find {|ur| uom =~ ur}
    size_std = $1
    size_unit_std = $2

    product_pieces_regex = [
        /(\d+)\s?per\s?pack/i,
        /(\d+)\s?pack/i,
        /(\d+)\s?pc[s]?/i,
        /(\d+)\s?pkt[s]?/i,
        /(?<![^\s])(\d+)\s?x\s?\d+/i,
        /[a-zA-Z]\s?x\s?(\d+)(?![^\s])/i,
        /(\d+)'?\s?s(?![^\s])/i,
    ].find {|ppr| uom =~ ppr}
    product_pieces = product_pieces_regex ? $1.to_i : 1
    product_pieces = 1 if product_pieces == 0
    product_pieces ||= 1

    description = Nokogiri.HTML(product["description"]).text

    img_url = nil
    img_check = product["images"][0]["url"]
    if img_check
    	img_url = img_check.include?("http") ? img_check : "https:#{img_check}"
    end

	is_available = product["stock"]["stockLevelStatus"]["code"] == "inStock"

	is_promoted = false
	type_of_promotion = nil
	promotion = ""

	unless product["promotionText"].empty? || product["promotionText"].nil?
		is_promoted = true
		type_of_promotion = "promotion text"
		promotion = "'#{product["promotionText"]}'"
	end

	promo_attributes = JSON.generate({
		"promo_detail" => "#{promotion}"
	})


	is_private_label = nil
	unless product_brand.empty? || product_brand.nil?
		is_private_label = product_brand =~ /hktv\s?mall/i ? false : true
	end


	total_reviews = product["numberOfReviews"].to_i
	avg_reviews = product["averageRating"].to_f
	reviews = JSON.generate({
		"num_total_reviews" => total_reviews,
        "num_avg_reviews" => avg_reviews,
	})


	store_reviews = JSON.generate({
		"num_total_reviews" => nil,
		"num_avg_reviews" => product["storeRating"]
	})


	item_identifiers = JSON.generate({
		"barcode" => "'#{product_id}'"
	})


	url = "https://www.hktvmall.com/hktv/en/#{product["url"]}"


	product_details = {
		#_collection: "product_list",
        #_id: product_id,
        competitor_name: "HKTVMALL",
        competitor_type: "dmart",
        store_name: product["storeName"],
        store_id: product["storeCode"],
        country_iso: "HK",
        language: "ENG",
        currency_code_lc: "HKD",
        #scraped_at_timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
        ###
        competitor_product_id: product_id,
        name: product["name"],
        brand: product_brand,
        #category_id: product["categories"][0]["code"],
        #category: product["categories"][0]["name"],
        sub_category: product["categories"][0]["name"],
        customer_price_lc: customer_price_lc,
        base_price_lc: base_price_lc,
        has_discount: has_discount,
        discount_percentage: discount_percentage,
        rank_in_listing: rank,
        page_number: current_page,
        product_pieces: product_pieces,
        size_std: size_std,
        size_unit_std: size_unit_std,
        #description: description,
        img_url: img_url,
        barcode: product_id,
        sku: nil,
        url: url,
        is_available: is_available,
        crawled_source: "WEB",
        is_promoted: is_promoted,
        type_of_promotion: type_of_promotion,
        promo_attributes: promo_attributes,
        is_private_label: is_private_label,
        latitude: nil,
        longitude: nil,
        reviews: reviews,
        store_reviews: store_reviews,
        item_attributes: nil,
        item_identifiers: item_identifiers,
        country_of_origin: product["countryOfOrigin"],
        variants: nil,
        #uom: uom,
	}


	pages << {
		page_type: "product",
		url: url,
		headers: {
			"Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
			"Accept-Encoding" => "gzip, deflate, br",
			"Accept-Language" => "en-US,en;q=0.5",
			"DNT" => "1",
			"Upgrade-Insecure-Requests" => "1",
		},
        vars: page["vars"].merge("product_details" => product_details),
	}
end