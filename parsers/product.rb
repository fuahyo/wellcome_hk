require "./lib/helpers"

vars = page["vars"]
brand_dict = vars["brand_dict"]
json = JSON.parse(content)
# File.open("productJson.json","w") do |f|
#     f.write(JSON.pretty_generate(json))
# end
prod = json["data"]


prod_id = prod["wareId"].to_s
prod_name = prod["wareName"]
prod_sku = prod["sku"].to_s

store_name = "WELLCOME"
store_id = vars["store_id"].to_s

brand = brand_dict["#{prod["brandId"]}"]
is_private_label = nil
if brand
    is_private_label = (brand =~ /wellcome/i) ? false : true
end

cat_id = vars["cat_id"].to_s
cat_name = vars["cat_name"]
subcat_name = vars["subcat"]

base_price_lc = (prod["warePrice"].to_f / 100.0)
customer_price_lc = (prod["promotionWareVO"]["unitProPrice"].to_f / 100.0)
has_discount = customer_price_lc < base_price_lc
discount_percentage = has_discount ? GetFunc::Get_Discount(base_price_lc, customer_price_lc) : nil

rank = vars["rank"]
page_number = vars["page_number"]

prod_pieces = GetFunc::Get_Pieces(prod_name)

uom = GetFunc::Get_Uom(prod_name)
size_std = uom[:size]
size_unit_std = uom[:unit]
description = nil
img_url = prod["wareImgList"][0]
is_available = prod["wareStock"] > 0

is_promoted = false
type_of_promotion = nil
promo_attributes = nil

promos_arr = []
promos = prod["promotionWareVO"]["promotionInfoList"].map { |i| i["displayInfo"]["proTag"] } rescue []
promos.each do |i|
    unless i.nil? || i.empty?
        promos_arr.append("'#{i}'")
    end
end
# File.open("productpromos_arr.json","w") do |f|
#     f.write(JSON.pretty_generate(promos_arr))
# end
unless promos_arr.empty?
    is_promoted = true
    type_of_promotion = "offer"
end

promo_attributes = JSON.generate({
    "promo_details" => promos_arr.join(", ")
})


latitude = vars["store_latitude"]
longitude = vars["store_longitude"]
reviews = nil
store_reviews = nil
item_attributes = nil

item_identifiers = JSON.generate({
    "barcode" => "'#{prod_id}'",
})

country_of_origin = prod["produceArea"]

newUrl = 'https://www.wellcome.com.hk/en/p/'+prod_name.gsub(' ', '%20')+'/i/'+prod_sku+'.html'
headers = { 
  'Cookie' => 'superweb-locale=en_US; pickUpStoreId=; shipmentType=1; venderId=5; _ga=GA1.1.262739087.1722497632;',
headers = { 
  'Cookie' => 'superweb-locale=en_US; pickUpStoreId=; shipmentType=1; venderId=5; _ga=GA1.1.262739087.1722497632;',
  'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
  'Accept-Encoding' => 'gzip, deflate, br, zstd',
  'Accept-Language' => 'en-US,en;q=0.9,es;q=0.8',
  'Cache-Control' => 'no-cache',
  'Connection' => 'keep-alive',
  'Host' => 'www.wellcome.com.hk',
  'Pragma' => 'no-cache',
  'Sec-Ch-Ua' => '"Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"',
  'Sec-Ch-Ua-Mobile' => '?0',
  'Sec-Ch-Ua-Platform' => '"macOS"',
  'Sec-Fetch-Dest' => 'document',
  'Sec-Fetch-Mode' => 'navigate',
  'Sec-Fetch-Site' => 'same-origin',
  'Sec-Fetch-User' => '?1',
  'Upgrade-Insecure-Requests' => '1',
  'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36'
} 
# outputs << {
pages << {
    url: newUrl,
    method: "GET",
    headers: headers,
    verify: false,
    page_type: "detail",
    vars: {
        _collection: "products",
        _id: prod_id,
        competitor_name: "WELLCOME",
        competitor_type: "dmart",
        store_name: store_name,
        store_id: store_id,
        country_iso: "HK",
        language: "ENG", #"CHI",
        currency_code_lc: "HKD",
        scraped_at_timestamp: ((ENV['needs_reparse'] == 1 || ENV['needs_reparse'] == "1") ? (Time.parse(page['fetched_at']) + 1).strftime('%Y-%m-%d %H:%M:%S') : Time.parse(page['fetched_at']).strftime('%Y-%m-%d %H:%M:%S')),
        ###
        competitor_product_id: prod_id,
        name: prod_name,
        brand: brand,
        category_id: cat_id,
        category: cat_name,
        sub_category: subcat_name,
        customer_price_lc: customer_price_lc,
        base_price_lc: base_price_lc,
        has_discount: has_discount,
        discount_percentage: discount_percentage,
        rank_in_listing: rank,
        page_number: page_number,
        product_pieces: prod_pieces,
        size_std: size_std,
        size_unit_std: size_unit_std,
        description: description,#########
        img_url: img_url,
        barcode: prod_id,
        sku: prod_sku,
        url: newUrl,
        is_available: is_available,
        crawled_source: "APP",
        is_promoted: is_promoted,
        type_of_promotion: type_of_promotion,
        promo_attributes: promo_attributes,
        is_private_label: is_private_label,
        latitude: latitude,
        longitude: longitude,
        reviews: reviews,
        store_reviews: store_reviews,
        item_attributes: item_attributes,
        item_identifiers: item_identifiers,
        country_of_origin: country_of_origin,
        variants: nil,
        img_url_2: prod['wareImgList'][1],
        img_url_3: prod['wareImgList'][2],
        img_url_4: prod['wareImgList'][3],
        nutrition_facts: nil,
        ingredients: nil,
        dimensions: nil,
        allergens: nil
    }
}

# File.open("productpage_arr.json","w") do |f|
#     f.write(JSON.pretty_generate(pages))
# end
