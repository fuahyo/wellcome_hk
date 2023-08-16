require "./lib/headers"
require "./lib/helpers"

PER_PAGE = 20
vars = page["vars"]
json = JSON.parse(content)
current_page = vars["page_number"]


#pagination
if current_page == 1
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
                vars: vars.merge("page_number" => pn)
            }
        end
    end

    outputs << {
        _collection: "first_listings_page_info",
        nav_gid: page["gid"],
        category_id: vars["cat_id"],
        category_name: vars["cat_name"],
        prod_count: json["data"]["pageInfo"]["total"],
        total_pages: total_pages,
    }
end


products = json["data"]["wareList"]
if products.empty? || products.nil?
    raise "empty listings page"
end

#iterating products
products.each_with_index do |prod, idx|
    rank = idx+1

    prod_id = prod["sku"]
    prod_name = prod["wareName"]

    #body = 'param={"sku":"prod_id"}'
    body = "param=%7B%22sku%22%3A%22#{prod_id}%22%7D"

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
        )
    }
end