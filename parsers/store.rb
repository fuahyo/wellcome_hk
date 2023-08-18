require "./lib/headers"

vars = page["vars"]
json = JSON.parse(content)

store_info = json["data"]["online"]["storeList"][0]
store_id = store_info["storeId"]
store_name = store_info["storeName"]
store_latitude = store_info["latitude"]
store_longitude = store_info["longitude"]

#####

body = "param="

pages << {
    page_type: "categories",
    url: "https://searchgw.rta-os.com/app/wareCategory/list",
    method: "POST",
    body: body,
    headers: ReqHeaders::AllHeaders,
    vars: vars.merge(
        "store_id" => store_id,
        "store_name" => store_name,
        "store_latitude" => store_latitude,
        "store_longitude" => store_longitude,
    )
}