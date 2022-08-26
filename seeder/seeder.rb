=begin
pages << {
	page_type: "locations",
	url: "https://www.wellcome.com.hk/en/our-store",

}
=end

###

=begin
require './lib/headers'
require 'csv'

locations = CSV.read('input/geo.csv')

locations.each_with_index do |location, idx|
  #skipping header
  if idx < 1
    next
  end

  lat = location[0]
  lng = location[1]

  nav = {
    "latitude" => lat,
    "longitude" => lng,
  }

  body = 'param={"wifiList":[{"signal":0}],"flowDeliveryTimeType":"1","onlineShowType":1,"onlineBizCode":1,"deliveryLocation":{"longitude":'+lng+',"latitude":'+lat+'}}'

  pages << {
      page_type: "stores",
      url: "https://flow.dmall.com.hk/app/home/business",
      method: "POST",
      body: body,
      headers: ReqHeaders::HEADERS,
      vars: {
        nav: nav,
      },
  }

end
=end

require './lib/headers'


body = 'param={"wifiList":[{"signal":0}],"flowDeliveryTimeType":"1","onlineShowType":1,"onlineBizCode":1,"deliveryLocation":{"longitude":114.1693611,"latitude":22.319303900000001}}'

pages << {
  page_type: "stores",
  url: "https://searchgw.dmall.com.hk/app/search/wareSearch",
  method: "POST",
  body: body,
  headers: ReqHeaders::Headers,
}