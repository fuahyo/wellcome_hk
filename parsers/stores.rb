require './lib/headers'

json = JSON.parse(content)


body = 'param={"stores":[{"venderId":"vender_id","name":"24小時送達","defaultChosed":false,"showTrack":false,"timestamp":"","erpStoreId":"store_id","businessCode":1}],"from":1}'

stores = json["data"]["online"]["storeList"]

stores.each do |store|
	vender_id = store["venderId"]
	store_id = store["storeId"]

	vender_name = store["venderName"]
	store_name = store["storeName"]

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
		},
	}
end