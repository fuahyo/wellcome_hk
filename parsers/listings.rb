require "./lib/headers"
require "./lib/helpers"

vars = page["vars"]
json = JSON.parse(content)
current_page = vars["page_number"]

products = json["data"]["wareList"]

if products.nil?
  outputs << {
    _collection: "empty_stores",
    _id: "#{vars["vender_id"]}_#{vars["store_id"]}",
    vender_id: vars["vender_id"],
    vender_name: vars["vender_name"],
    store_id: vars["store_id"],
    store_name: vars["store_name"],
  }
else
  if current_page == 1
    total_page = json["data"]["pageInfo"]["pageCount"]
    if total_page > 1
      (2..total_page).each do |pn|
        body = page["body"].gsub('"pageNum":1', "\"pageNum\":#{pn}")

        pages << {
          page_type: "listings",
          url: page["url"],
          method: "POST",
          body: body,
          headers: page["vars"]["headers"],
          vars: vars.merge("page_number" => pn),
        }
      end
    end
  end

  #iterating products
  products.each_with_index do |prod, idx|
    rank = idx + 1

    prod_id = prod["wareId"]
    sku = prod["sku"]
    prod_name = prod["wareName"]

    customer_price_lc = prod["onlinePromotionPrice"] / 100.0
    base_price_lc = prod["onlinePrice"] / 100.0
    has_discount = customer_price_lc < base_price_lc
    discount_percentage = has_discount ? GetFunc::Get_Discount(base_price_lc, customer_price_lc) : nil

    prod_pieces = GetFunc::Get_Pieces(prod_name)

    uom = GetFunc::Get_Uom(prod_name)
    size_std = uom[:size]
    size_unit_std = uom[:unit]

    img_url = prod["wareImg"]
    is_available = prod["sell"]

    is_promoted = false
    type_of_promotion = nil
    promo_attributes = nil

    promos = []
    promotions = prod["promotionWareVO"]["promotionInfoList"].map { |i| i["displayInfo"]["proTag"] } rescue []
    promotions.each do |i|
      unless i.nil? || i.empty?
        promos.append("'#{i}'")
      end
    end

    unless promos.empty?
      is_promoted = true
      type_of_promotion = "tag"

      promo_attributes = JSON.generate({
        "promo_details" => promos.join(", "),
      })
    end

    item_identifiers = JSON.generate({
      "barcode" => "'#{prod_id}'",
    })

    # id = "#{prod_id}_#{vars["store_id"]}"

    outputs << {
      _collection: "products",
      _id: prod_id,
      competitor_name: "WELLCOME",
      competitor_type: "dmart",
      store_name: page["vars"]["store_name"],
      store_id: page["vars"]["store_id"],
      country_iso: "HK",
      language: "ENG", #"CHI",
      currency_code_lc: "HKD",
      scraped_at_timestamp: (ENV['reparse'] == "1" ? (Time.parse(page['fetched_at']) + 1).strftime('%Y-%m-%d %H:%M:%S') : Time.parse(page['fetched_at']).strftime('%Y-%m-%d %H:%M:%S')),
      ###
      competitor_product_id: prod_id,
      name: prod_name,
      brand: nil,
      category_id: nil, #page["vars"]["category_id"],
      category: nil, #page["vars"]["category_name"],
      sub_category: nil,
      customer_price_lc: customer_price_lc,
      base_price_lc: base_price_lc,
      has_discount: has_discount,
      discount_percentage: discount_percentage,
      rank_in_listing: rank,
      page_number: current_page,
      product_pieces: prod_pieces,
      size_std: size_std,
      size_unit_std: size_unit_std,
      description: nil,
      img_url: img_url,
      barcode: prod_id,
      sku: sku,
      url: nil,
      is_available: is_available,
      crawled_source: "APP",
      is_promoted: is_promoted,
      type_of_promotion: type_of_promotion,
      promo_attributes: promo_attributes,
      is_private_label: nil,
      latitude: page["vars"]["latitude"],
      longitude: page["vars"]["longitude"],
      reviews: nil,
      store_reviews: nil,
      item_attributes: nil,
      item_identifiers: item_identifiers,
      country_of_origin: nil,
      variants: nil,
    }
  end
end
