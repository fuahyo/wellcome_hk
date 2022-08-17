require './lib/headers'

html=Nokogiri::HTML(content)

locations = html.css('.store-title')

locations.each do |location|

  coordinates = location.attr('data-latlng')
  lat,lng = coordinates.split("|")
  body = 'param={"wifiList":[{"signal":0}],"flowDeliveryTimeType":"1","onlineShowType":1,"onlineBizCode":1,"deliveryLocation":{"longitude":'+lat+',"latitude":'+lng+'}}'

  pages << {
      page_type: "stores",
      url: "https://flow.dmall.com.hk/app/home/business",
      method: "POST",
      body: body,
      headers: ReqHeaders::HEADERS,
  }

end

