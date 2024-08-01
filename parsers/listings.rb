require "./lib/headers"
require "./lib/helpers"

PER_PAGE = 20
vars = page["vars"]
json = JSON.parse(content)
current_page = vars["page_number"]

brand_dict = vars["brand_dict"]

if current_page == 1
    #to make brand list
    brand_dict = {}

    json["data"]["properties"].each do |prop|
        if prop["propertyName"] == "Brands"
            prop["childProperties"].each do |brand|
                brand_id_arr = brand["propertyId"].split(",").map {|i| i.strip}
                brand_id_arr.each do |brand_id|
                    brand_dict["#{brand_id}"] = brand["propertyName"]
                end
            end
        end
    end
    
    if brand_dict.count < 1
        outputs << {
            _collection: "subcat_no_brands",
            nav_gid: page["gid"],
            category_id: vars["cat_id"],
            category_name: vars["cat_name"],
            subcategory: vars["subcat"],
        }
    end


    #pagination
    total_pages = json["data"]["pageInfo"]["pageCount"]

    if total_pages > 1
        (2..total_pages).each do |pn|
            #body = page["body"].gsub('"pageNum":"1"', '"pageNum":"pn"')
            body = page["body"].gsub("%22pageNum%22%3A%221%22", "%22pageNum%22%3A%22#{pn}%22")

            pages << {
                page_type: "listings",
                url: "https://searchgw.rta-os.com/app/search/wareSearch",
                method: "POST",
                priority: 90,
                body: body,
                headers: ReqHeaders::AllHeaders,
                vars: vars.merge(
                    "page_number" => pn,
                    "brand_dict" => brand_dict,
                )
            }
        end
    end

    #log collection
    outputs << {
        _collection: "first_listings_page_info",
        nav_gid: page["gid"],
        category_id: vars["cat_id"],
        category_name: vars["cat_name"],
        subcategory: vars["subcat"],
        prod_count: json["data"]["pageInfo"]["total"],
        total_pages: total_pages,
    }
end


products = json["data"]["wareList"]
# File.open("listingjson.json","w") do |f|
#     f.write(JSON.pretty_generate(json))
# end
if products.empty? || products.nil?
    raise "empty listings page"
end

#iterating products
products.each_with_index do |prod, idx|
    rank = idx+1

    prod_id = prod["wareId"]
    prod_name = prod["wareName"]
    prod_sku = prod["sku"]

    body = 'param={"lat":22.2847577,"lng":114.1326485,"sku":"prod_sku"}'
    body = "param=%7B%22lat%22%3A#{vars["input_location"]["lat"]}%2C%22lng%22%3A#{vars["input_location"]["lng"]}%2C%22sku%22%3A%22#{prod_sku}%22%7D"

    pages << {
        page_type: "product",
        url: "https://detail.rta-os.com/app/wareDetail/baseinfo",
        method: "POST",
        priority: 80,
        body: body,
        headers: ReqHeaders::AllHeaders,
        vars: vars.merge(
            "rank" => rank,
            "prod_id" => prod_id,
            "prod_name" => prod_name,
            "prod_sku" => prod_sku,
            "brand_dict" => brand_dict,
        )
    }
end

# File.open("listingOutput_arr.json","w") do |f|
#     f.write(JSON.pretty_generate(outputs))
# end
# File.open("listingpage.json","w") do |f|
#     f.write(JSON.pretty_generate(pages))
# end