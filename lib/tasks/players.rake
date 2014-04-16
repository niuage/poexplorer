namespace :players do

  def create_all_missing_characters(players_data, league_id)
    character_names = players_data.map { |pd| pd["character"]["name"] }
    existing_character_names = Player
    .by_league(league_id)
    .by_character(character_names)
    .pluck(:character)

    missing_players_data = players_data.reject { |pd| pd["character"]["name"].in? [existing_character_names] }

    ActiveRecord::Base.transaction do
      Player.create_all_from_api(missing_players_data, league_id)
    end
  end

  def mark_untouched_players_as_offline(league_id, starting_time)
    players = Player
      .by_league(league_id)
      .not_marked_online
      .updated_before(starting_time)

    players.update_all(online: false, updated_at: Time.zone.now)
    players.find_in_batches { |ps| TireIndex.store(league_id, ps) }
  end

  def update_online_characters_status_in_elasticsearch(league_id, starting_time)
    Player
      .by_league(league_id)
      .updated_after(starting_time)
      .online
      .find_in_batches do |players|
        puts "reupdating ", players.length, " players"
        TireIndex.store(league_id, players)
      end
  end

  def mark_players_as_online(league_id, online_data)
    online_character_names = online_data.map { |p| p["character"]["name"] }

    # get all the actual PoExplorer players
    online_players = Player
      .by_league(league_id)
      .by_character(online_character_names)

    online_players.update_all(
      online: true,
      updated_at: Time.zone.now,
      last_online: Time.zone.now
      )

    TireIndex.store(league_id, online_players)
  end

  def mark_players_as_offline(league_id, offline_data)
    offline_character_names = offline_data.map { |p| p["character"]["name"] }

    offline_players = Player.not_marked_online
      .by_league(league_id)
      .by_character(offline_character_names)

    Player.mark_offline(offline_players, league_id)
  end

  task :import => :environment do
    while true do
      League.running.each do |league|
        next unless League.visible?(league.name)
        league_name = league.name
        league_id = league.id

        puts league_name

        api = PoeApi.new(league_name)

        starting_time = Time.zone.now

        (0..74).each do |request_nb|
          offset = request_nb * PoeApi::LIMIT
          puts "New api request #{offset}"

          api.ladder(offset) do |response|
            raise response.code.to_s unless response.code == 200

            players_data = ActiveSupport::JSON.decode(response.body)["entries"]

            # all characters now exists
            create_all_missing_characters(players_data, league_id)

            # get the players data, split by online status
            online_data, offline_data = players_data.partition do |player|
              player["online"]
            end

            mark_players_as_offline(league_id, offline_data)
            mark_players_as_online(league_id, online_data)
          end
        end

        # accounts with an online character and an offline character
        # could potentially have offline status in ES (overriden by offline character)
        update_online_characters_status_in_elasticsearch(league_id, starting_time)

        # players that haven't been touched, and that are not manually set
        # to online are set to offline
        mark_untouched_players_as_offline(league_id, starting_time)
      end
      # sleep(15*60)
    end
  end
end
