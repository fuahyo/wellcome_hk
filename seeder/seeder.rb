# require "./lib/headers"


# #default lat&lng given by the APP
# input_location = {
#     "lat" => 22.2847577,
#     "lng" => 114.1326485
# }

# #body = param={"deliveryLocation":{"latitude":22.2847577,"longitude":114.1326485},"flowDeliveryTimeType":"1","onlineBizCode":1,"onlineShowType":1,"onlineStore":"551004","userLocation":{"latitude":22.2847577,"longitude":114.1326485},"venderBrandIds":"5,6"}
# body = "param=%7B%22deliveryLocation%22%3A%7B%22latitude%22%3A#{input_location["lat"]}%2C%22longitude%22%3A#{input_location["lng"]}%7D%2C%22flowDeliveryTimeType%22%3A%221%22%2C%22onlineBizCode%22%3A1%2C%22onlineShowType%22%3A1%2C%22onlineStore%22%3A%22551004%22%2C%22userLocation%22%3A%7B%22latitude%22%3A#{input_location["lat"]}%2C%22longitude%22%3A#{input_location["lng"]}%7D%2C%22venderBrandIds%22%3A%225%2C6%22%7D"

# pages << {
#     page_type: "store",
#     url: "https://flow.rta-os.com/app/home/business",
#     method: "POST",
#     body: body,
#     headers: ReqHeaders::StoreHeaders,
#     vars: {
#         input_location: input_location,
#     }
# }

newUrl = 'https://www.wellcome.com.hk/en/p/Vinda%20Premium%20Bathroom%20Tissue%2010RL/i/101322998.html'
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
pages << {
    url: newUrl,
    method: "GET",
    headers: headers,
    verify: false,
    page_type: "detail",
    vars: {
      _collection: "products",
      _id: "19226079",
      competitor_name: "WELLCOME",
      competitor_type: "dmart",
      store_name: "WELLCOME",
      store_id: "43",
      country_iso: "HK",
      language: "ENG",
      currency_code_lc: "HKD",
      scraped_at_timestamp: "2024-07-28 19:42:38",
      competitor_product_id: "19226079",
      name: "I.Pet Air Anti Odor & Bacterial Granutes 50GM",
      brand: "I.PET AIR",
      category_id: "100018",
      category: "Pet Supplies",
      sub_category: "Cat > Litter & Toilet",
      customer_price_lc: 55.0,
      base_price_lc: 55.0,
      has_discount: false,
      discount_percentage: nil,
      rank_in_listing: 9,
      page_number: 1,
      product_pieces: 1,
      size_std: "50",
      size_unit_std: "GM",
      description: nil,
      img_url: "https://img.rtacdn-os.com/20230404/251df57a-0c76-4b2c-b2b8-f94cc61c6a0e_800x800H",
      barcode: "19226079",
      sku: "113256809",
      url: newUrl,
      is_available: true,
      crawled_source: "APP",
      is_promoted: false,
      type_of_promotion: nil,
      promo_attributes: "{\"promo_details\":\"\"}",
      is_private_label: true,
      latitude: 22.284968,
      longitude: 114.133252,
      reviews: nil,
      store_reviews: nil,
      item_attributes: nil,
      item_identifiers: "{\"barcode\":\"'19226079'\"}",
      country_of_origin: "China",
      variants: nil,
      img_url_2: nil,
      img_url_3: nil,
      img_url_4: nil,
      nutrition_facts: nil,
      ingredients: nil,
      dimensions: nil,
      allergens: nil
    }
}
