require './lib/headers'

json = JSON.parse(content)


body = 'param={"src":0,"pageSize":20,"sort":0,"isOffline":false,"categoryLevel":1,"sortRule":0,"sortKey":0,"noResultSearch":0,"promoting":0,"erpStoreId":"store_id","brandId":"0","businessCode":1,"pos":0,"categorySkuId":0,"pageNum":1,"from":3,"globalSelection":false,"filterProperties":[],"venderId":"vender_id","categoryId":"category_id","categoryType":1}'

categories = json["data"][0]["categoryList"]

if categories.empty?
    outputs << {
        _collection: "empty_categories",
        store_id: page["vars"]["store_id"],
        store_name: page["vars"]["store_name"],
        vender_id: page["vars"]["vender_id"],
        vender_name: page["vars"]["vender_name"],
    }
else
    categories.each do |category|
        category_id = category["categoryId"]
        category_name = category["categoryName"]

        body = body.gsub("store_id", page["vars"]["store_id"]).gsub("vender_id", page["vars"]["vender_id"]).gsub("category_id", category_id)
        headers = ReqHeaders::HEADERS.merge(
            "Storeid" => page["vars"]["store_id"],
            "Venderid" => page["vars"]["vender_id"],
        )

        pages << {
            page_type: "listings",
            url: "https://searchgw.dmall.com.hk/app/search/wareSearch",
            method: "POST",
            body: body,
            headers: headers,
            vars: page["vars"].merge(
                category_id: category_id,
                category_name: category_name,
                page_number: 1,
                headers: headers,
            ),
        }
    end
end