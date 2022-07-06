require './lib/headers'


html = Nokogiri.HTML(content)


categories = html.css("#subnav > ul > li[data-category-code] > a")

categories_dict = {}

categories.each do |cat|
    cat_id = cat["data-maincat"]
    cat_name = cat.text.strip.gsub(/&nbsp$/, "")

    categories_dict["#{cat_id}"] = {
        "category_id" => cat_id,
        "category_name" => cat_name,
    }
end


categories_dict.each do |k, v|
    category_id = v["category_id"]
    category_name = v["category_name"]
    url = "https://www.hktvmall.com/hktv/en/ajax/search_products?query=:relevance:street:main:category:#{category_id}:&currentPage=0&pageSize=60&pageType=searchResult&categoryCode=#{category_id}"

    pages << {
        page_type: "listings",
        url: url,
        priority: 100,
        headers: ReqHeaders::HEADERS,
        vars: {
            nav: {
                category_id: category_id,
                category_name: category_name,
            },
            page_number: 1,
            #categories_dict: categories_dict,
        }
    }
end