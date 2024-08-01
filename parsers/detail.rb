vars = page["vars"]
html = Nokogiri::HTML(content)

list_promo_attributes = []
html.css('.offer-item').each do |item|
  promo_text = item.at_css('.info-content .tag')&.text&.strip
  list_promo_attributes << promo_text if promo_text
end

promo_attributes = list_promo_attributes.join(', ') 
if vars['promo_attributes'] == "{\"promo_details\":\"\"}" 
  vars['promo_attributes'] = "{\"promo_details\":\""+(promo_attributes || "")+"\"}"
  vars['type_of_promotion'] = 'Offers' if !promo_attributes.nil?
  vars['is_promoted'] = !promo_attributes.nil?
end
 
output << vars
