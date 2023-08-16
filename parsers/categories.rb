require './lib/headers'

json = JSON.parse(content)

store_info = json["data"]["wareCategory"][0]["store"]

vender_id = store_info["venderId"]
erp_store_id = store_info["erpStoreId"]
business_code = store_info["businessCode"]


categories = json["data"]["wareCategory"][0]["categoryList"]
categories.each do |cat|
    cat_id = cat["categoryId"]
    cat_name = cat["categoryName"]

    #body = 'param={"brandId":"","businessCode":1,"categoryId":"cat_id","categoryLevel":1,"categorySkuId":0,"categoryType":1,"erpStoreId":"551004","filterProperties":[],"from":1,"globalSelection":false,"noResultSearch":0,"pos":1,"promoting":0,"sortKey":0,"sortRule":0,"src":0,"venderId":"5","pageNum":"1","pageSize":"20"}'
    body = "param=%7B%22brandId%22%3A%22%22%2C%22businessCode%22%3A1%2C%22categoryId%22%3A%22#{cat_id}%22%2C%22categoryLevel%22%3A1%2C%22categorySkuId%22%3A0%2C%22categoryType%22%3A1%2C%22erpStoreId%22%3A%22551004%22%2C%22filterProperties%22%3A%5B%5D%2C%22from%22%3A1%2C%22globalSelection%22%3Afalse%2C%22noResultSearch%22%3A0%2C%22pos%22%3A1%2C%22promoting%22%3A0%2C%22sortKey%22%3A0%2C%22sortRule%22%3A0%2C%22src%22%3A0%2C%22venderId%22%3A%225%22%2C%22pageNum%22%3A%221%22%2C%22pageSize%22%3A%2220%22%7D"

    pages << {
        page_type: "listings",
        url: "https://searchgw.rta-os.com/app/search/wareSearch",
        method: "POST",
        body: body,
        headers: ReqHeaders::AllHeaders,
        vars: {
            vender_id: vender_id,
            erp_store_id: erp_store_id,
            business_code: business_code,
            cat_id: cat_id,
            cat_name: cat_name,
            page_number: 1,
        }
    }
end