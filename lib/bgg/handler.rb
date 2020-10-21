class Bgg::Handler
  FETCH_COLLECTION_BASE_URL = 'https://www.boardgamegeek.com/xmlapi2/collection'.freeze

  def self.fetch_user_games(username, filters: {})
    HTTParty.get(FETCH_COLLECTION_BASE_URL + "?username=#{username}&own=1")
    sleep(10)
    bgg_response = HTTParty.get(FETCH_COLLECTION_BASE_URL + "?username=#{username}&own=1")

    bgg_response.to_h.with_indifferent_access[:items][:item].map do |game|
      {
        name: game[:name][:__content__],
        bgg_id: game[:objectid],
        plays: game[:numplays].to_i
      }
    end
  end

  def self.unplayed_common_games(usernames)
    if(usernames.count <= 1)
      puts "More players needed!"

      return
    end

    player_common_games = []
    usernames.each do |user|
      if player_common_games.empty?
        player_common_games = fetch_user_games(user).select{|game| game[:plays] == 0}
      else
        player_common_games &= fetch_user_games(user).select{|game| game[:plays] == 0}
      end
    end.uniq

    player_common_games
  end

  def self.most_played_games(username, limit = 10)
    user_games = fetch_user_games(username)

    user_games.sort_by{|gm| gm[:plays]}.reverse.take(limit)
  end
end
