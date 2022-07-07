module GetFunc
    class << self
        def get_uom(x)
        	uom_regex = [
                /(?<![^\s])(\d*[\.,]?\d+)\s?(克)(?![^\s])/i,
                /(?<![^\s])(\d*[\.,]?\d+)\s?(毫升)(?![^\s])/i,
                #
                /(?<![^\s])(\d*[\.,]?\d+)\s?(litre[s]?)(?![^\s])/i,
                /(?<![^\s])(\d*[\.,]?\d+)\s?(fl oz)(?![^\s])/i,
                /(?<![^\s])(\d*[\.,]?\d+)\s?([mcf]?l)(?![^\s])/i,
                /(?<![^\s])(\d*[\.,]?\d+)\s?([mk]?g)(?![^\s])/i,
                /(?<![^\s])(\d*[\.,]?\d+)\s?([mc]?m)(?![^\s])/i,
                /(?<![^\s])(\d*[\.,]?\d+)\s?(oz)(?![^\s])/i,
            ]
            uom_regex.find {|ur| x =~ ur}
            size_std = $1
            size_unit_std = $2

            uom = {
        		size: $1,
        		unit: $2,
        	}

        	return uom
        end


        def get_pieces(x)
        	product_pieces_regex = [
                /(\d+)\s?片(?![^\s])/i,
                #
                /(\d+)\s?per\s?pack/i,
                /(\d+)\s?pack/i,
                /(\d+)\s?pc[s]?/i,
                /(\d+)\s?pkt[s]?/i,
                /(?<![^\s])(\d+)\s?x\s?\d+/i,
                /[a-zA-Z]\s?x\s?(\d+)(?![^\s])/i,
                /(\d+)'?\s?s(?![^\s])/i,
            ].find {|ppr| x =~ ppr}
            product_pieces = product_pieces_regex ? $1.to_i : 1
            product_pieces = 1 if product_pieces == 0
            product_pieces ||= 1

            return product_pieces
        end


        def get_discount(base_price, customer_price)
        	discount = (((base_price - customer_price) / base_price.to_f) * 100).round(7)

        	return discount
        end
    end
end