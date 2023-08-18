require "./lib/headers"


#default lat&lng given by the APP
input_location = {
    "lat" => 22.2847577,
    "lng" => 114.1326485
}

#body = param={"deliveryLocation":{"latitude":22.2847577,"longitude":114.1326485},"flowDeliveryTimeType":"1","onlineBizCode":1,"onlineShowType":1,"onlineStore":"551004","userLocation":{"latitude":22.2847577,"longitude":114.1326485},"venderBrandIds":"5,6"}
body = "param=%7B%22deliveryLocation%22%3A%7B%22latitude%22%3A#{input_location["lat"]}%2C%22longitude%22%3A#{input_location["lng"]}%7D%2C%22flowDeliveryTimeType%22%3A%221%22%2C%22onlineBizCode%22%3A1%2C%22onlineShowType%22%3A1%2C%22onlineStore%22%3A%22551004%22%2C%22userLocation%22%3A%7B%22latitude%22%3A#{input_location["lat"]}%2C%22longitude%22%3A#{input_location["lng"]}%7D%2C%22venderBrandIds%22%3A%225%2C6%22%7D"

pages << {
    page_type: "store",
    url: "https://flow.rta-os.com/app/home/business",
    method: "POST",
    body: body,
    headers: ReqHeaders::StoreHeaders,
    vars: {
        input_location: input_location,
    }
}