require './lib/headers'

body = 'param={"wifiList":[{"signal":0}],"flowDeliveryTimeType":"1","onlineShowType":1,"onlineBizCode":1,"deliveryLocation":{"longitude":114.1693611,"latitude":22.319303900000001}}'

pages << {
	page_type: "stores",
	url: "https://flow.dmall.com.hk/app/home/business",
	method: "POST",
	body: body,
	headers: ReqHeaders::HEADERS,
}