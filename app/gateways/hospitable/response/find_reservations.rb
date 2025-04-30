module Hospitable
  class Response
    class FindReservations < Response

      def reservations
        body["data"].map do |reservation|
          res = reservation.with_indifferent_access
          property = res[:properties].first
          guest = res[:guest]
          {
            id: res[:id],
            code: res[:code],
            arrival_date: res[:arrival_date],
            departure_date: res[:departure_date],
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
        end
      end
    end
  end
end


