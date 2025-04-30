module Hospitable
  class Response
    class FindReservations < Response

      def reservations
        body["data"].map do |reservation|
          res = reservation.with_indifferent_access

          next if res[:reservation_status][:current][:category] == "cancelled"
          # next if res[:status_history].last[:status] == "canceled"

          property = res[:properties].first
          guest = res[:guest]
          # binding.pry if guest[:first_name] == "Manuela"
          {
            id: res[:id],
            code: res[:code],
            arrival_date: res[:check_in],
            departure_date: res[:check_out],
            infant_count: res[:guests][:infant_count],
            nights: res[:nights],
            property: {
              id: property[:id],
              name: property[:name],
            },
            guest: {
              first_name: guest[:first_name],
              last_name: guest[:last_name],
              language: guest[:language],
              location: guest[:location],
            }
          }
        end.compact!
      end
    end
  end
end


