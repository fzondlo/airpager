module Hospitable
  class Response
    class FindReservations < Response
      # MAKE SURE THESE MATCH THA NAMES IN Task:Mapping!
      APARTMENT_NAME_MAPPINGS = {
        "Murano" => "Murano 901",
        "Lauret" => "Lauret 902",
        "Alans Apartment" => "Santa Ana 1001 (Alan)",
        "Modern Urban Apt w Designer" => "Santa Maria 302 (Yuri)",
        "Nebraska" => "Nebraska 1101",
        "Santa Maria 402 Yuri" => "Santa Maria 402 (Yuri)",
        "Edgar 201" => "Santa Maria 201 (Edgar)",
        "Angelas Apartment" => "Castelmola 301 (Angela)",
        "202 Santa Maria" => "Santa Maria 202",
        "501 Castelmola Bertha" => "Castelmola 501 (Bertha)"
      }

      def reservations
        body["data"].map do |reservation|
          res = reservation.with_indifferent_access
          property = res[:properties].first
          guest = res[:guest]
          # binding.pry if guest[:first_name] == "Alan"
          {
            id: res[:id],
            code: res[:code],
            status: res[:reservation_status][:current][:category],
            arrival_time: Time.parse(res[:check_in]),
            departure_time: Time.parse(res[:check_out]),
            infant_count: res[:guests][:infant_count],
            nights: res[:nights],
            property: {
              id: property[:id],
              name: APARTMENT_NAME_MAPPINGS[property[:name]]
            },
            guest: {
              first_name: guest[:first_name],
              last_name: guest[:last_name],
              language: guest[:language],
              location: guest[:location]
            }
          }
        end.compact
      end
    end
  end
end
