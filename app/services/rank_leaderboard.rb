class RankLeaderboard < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    # get all users
    users = User.all

    # get stats for each user
    users_stats = []
    users.each do |user|
      stats = CalculateUserStats.call(user)
      users_stats.push stats.merge(username: user.username, rank: 1)
    end

    # sort users by score (highest first)
    users_stats = users_stats.sort { |a, b| b[:score] <=> a[:score] }

    # calculate the rank for each user
    rank = 0
    rank_raw = 0
    previous_score = 0
    users_stats.each do |user_stat|
      # check for a score tie
      rank = rank_raw + 1 unless user_stat[:score] == previous_score
      rank_raw += 1

      user_stat[:rank] = rank
      previous_score = user_stat[:score]
    end

    users_stats
  end
end
