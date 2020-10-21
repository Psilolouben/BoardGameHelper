class Bgg::Handler
  FETCH_COLLECTION_BASE_URL = 'https://www.boardgamegeek.com/xmlapi2/collection'.freeze

  def self.fetch_user_games(username, filters: {})
    HTTParty.get(FETCH_COLLECTION_BASE_URL + "?username=#{username}&own=1")
    sleep(10)
    bgg_response = HTTParty.get(FETCH_COLLECTION_BASE_URL + "?username=#{username}&own=1")

    bgg_response.to_h.with_indifferent_access[:items][:item].map {|x| { name: x[:name][:__content__], bgg_id: x[:objectid] } }
  end
end
