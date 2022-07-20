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

	customer_price_lc = product["onlinePromotionPrice"]/100.0
	base_price_lc = product["onlinePrice"]/100.0
	has_discount = customer_price_lc < base_price_lc
	discount_percentage = has_discount ? GetFunc::get_discount(base_price_lc, customer_price_lc) : nil

	product_pieces = GetFunc::get_pieces(product_name)

	uom = GetFunc::get_uom(product_name)
	size_std = uom[:size]
	size_unit_std = uom[:unit]

	item_identifiers = JSON.generate({
		"barcode" => "'#{product_id}'"
	})

	outputs << {
		_collection: "product_list",
        #_id: product_id,
        competitor_name: "WELLCOME",
        competitor_type: "dmart",
        store_name: page["vars"]["store_name"],
        store_id: page["vars"]["store_id"],
        country_iso: "HK",
        language: "CHI",
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
        img_url: product["wareImg"],
        barcode: product_id,
        sku: product["sku"],
        url: nil,
        is_available: true,
        crawled_source: "APP",
        is_promoted: false,
        type_of_promotion: nil, #type_of_promotion,
        promo_attributes: nil, #promo_attributes,
        is_private_label: nil, #is_private_label,
        latitude: page["vars"]["latitude"],
        longitude: page["vars"]["longitude"],
        reviews: nil, #reviews,
        store_reviews: nil, #store_reviews,
        item_attributes: nil,
        item_identifiers: item_identifiers,
        country_of_origin: nil,
        variants: nil,
	}
end