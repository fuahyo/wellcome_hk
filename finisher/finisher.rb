i = 1
product_list = []
begin
  outputs = find_outputs("product_list", {}, i, 500)

  outputs.each do |output|
    unless product_list.include?(output["competitor_product_id"])
      product_list.append(output["competitor_product_id"])
    end
  end

  i += 1
end while outputs.length > 0


product_list.each do |product|
  un_outputs = find_outputs("product_list", {"competitor_product_id": product}, 1, 500)

  filtered_output = un_outputs[0]

  filtered_output["_collection"] = "products"

  outputs << filtered_output

  save_outputs outputs if outputs.length > 99
end

save_outputs outputs