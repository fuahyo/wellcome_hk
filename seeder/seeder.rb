require "./lib/headers"

body = "param="

pages << {
    page_type: "categories",
    url: "https://searchgw.rta-os.com/app/wareCategory/list",
    method: "POST",
    body: body,
    headers: ReqHeaders::AllHeaders,
}