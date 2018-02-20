#!/usr/bin/env ruby

require('plist')

open('FlaneurOpenSecretInfo.plist', 'w') do |f|
  f << {
    :'GooglePlacesFlaneurOpenAPIKey' => ENV['GOOGLE_PLACES_FLANEUR_API_KEY'].to_s
  }.to_plist
end
