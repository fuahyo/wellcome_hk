require './lib/headers'

vars = page["vars"]
json = JSON.parse(content)

=begin
#body = 'param={"stores":[{"venderId":"vender_id","name":"24小時送達","defaultChosed":false,"showTrack":false,"timestamp":"","erpStoreId":"store_id","businessCode":1}],"from":1}'
body = 'param={"stores":[{"venderId":"vender_id","name":"Full Basket Order","defaultChosed":false,"showTrack":false,"timestamp":"","erpStoreId":"store_id","businessCode":1}],"from":1}'

stores = json["data"]["online"]["storeList"]

outputs << {
	_collection: "stores_count_by_coordinate",
	stores_found: stores.count,
	latitude: vars["nav"]["latitude"],
	longitude: vars["nav"]["longitude"],
}

stores.each do |store|
	vender_id = store["venderId"].to_s
	store_id = store["storeId"].to_s

	vender_name = store["venderName"]
	store_name = store["storeName"]

	latitude = store["latitude"]
	longitude = store["longitude"]

	pages << {
		page_type: "categories",
		url: "https://searchgw.dmall.com.hk/app/wareCategory/multi/list",
		method: "POST",
		body: body.gsub("vender_id", vender_id).gsub("store_id", store_id),
		headers: ReqHeaders::HEADERS,
		vars: {
			vender_id: vender_id,
			store_id: store_id,
			vender_name: vender_name,
			store_name: store_name,
			latitude: latitude,
			longitude: longitude,
		}.merge("nav" => vars["nav"]),
	}
end
=end


body = 'param={"src":2,"stores":[{"venderId":"vender_id","name":"Full Basket Order","defaultChosed":false,"showTrack":false,"erpStoreId":"store_id","businessCode":1}],"pageSize":200,"keyword":"","sort":0,"isOffline":false,"categoryLevel":0,"sortRule":0,"sortKey":0,"noResultSearch":0,"promoting":0,"erpStoreId":"store_id","businessCode":1,"pos":1,"categorySkuId":0,"pageNum":1,"from":2,"globalSelection":false,"filterProperties":[],"venderId":"vender_id","categoryType":0}'
headers_clone = ReqHeaders::ListingsHeaders.clone

stores = json["data"]["online"]["storeList"]

outputs << {
	_collection: "stores_count_by_coordinate",
	stores_found: stores.count,
	latitude: vars["nav"]["latitude"],
	longitude: vars["nav"]["longitude"],
}

stores.each do |store|
	vender_id = store["venderId"].to_s
	store_id = store["storeId"].to_s

	vender_name = store["venderName"]
	store_name = store["storeName"]

	latitude = store["latitude"]
	longitude = store["longitude"]

	headers = headers_clone.merge(
		"Venderid" => vender_id,
		"Storeid" => store_id,
	)

	pages << {
		page_type: "listings",
		#url: "https://searchgw.dmall.com.hk/app/wareCategory/multi/list",
		url: "https://searchgw.dmall.com.hk/app/search/wareSearch",
		method: "POST",
		body: body.gsub("vender_id", vender_id).gsub("store_id", store_id),
		headers: headers,
		vars: {
			vender_id: vender_id,
			store_id: store_id,
			vender_name: vender_name,
			store_name: store_name,
			latitude: latitude,
			longitude: longitude,
			page_number: 1,
			headers: headers,
		}.merge("nav" => vars["nav"]),
	}
end