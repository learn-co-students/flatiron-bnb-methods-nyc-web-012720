module Placeable
    extend ActiveSupport::Concern
    
    def openings(start_date, end_date)
        sd = DateTime.strptime(start_date, '%Y-%m-%d')
        ed = DateTime.strptime(end_date, '%Y-%m-%d')
        available = []
        self.listings.each do |listing|
            is_available = true
            listing.reservations.each do |res|
                if sd.between?(res.checkin, res.checkout) || ed.between?(res.checkin, res.checkout)
                    is_available = false
                end
            end
            if is_available
            available << listing
            end
        end
        available
    end

    class_methods do
        def highest_ratio_res_to_listings
            city_with_highest = nil
            highest_ratio = 0
            all.each do |city|
              denominator = city.listings.count
              numerator = 0
              city.listings.each do |listing|
                numerator += listing.reservations.count
              end

              denominator != 0 ? ratio = numerator/denominator : ratio = 0

              if ratio > highest_ratio
                highest_ratio = ratio
                city_with_highest = city
              end
            end
            city_with_highest
          end
        
          def most_res
            city_with_most = nil
            most_res_count = 0
            all.each do |city|
              city_res_count = 0
              city.listings.each do |listing|
                city_res_count += listing.reservations.count
              end
              if city_res_count > most_res_count
                most_res_count = city_res_count
                city_with_most = city
              end
            end
            city_with_most
          end
    end
end