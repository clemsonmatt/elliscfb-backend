class WeeklyEmailReminder < ApplicationService
  def initialize(week)
    @week = week

    # find pickem games for the week
    games = games_for_week
    @game_ids = games.map(&:id)
  end

  def call
    # get everyone who hasn't picked this week
    people_not_picked = []

    people = User.all
    people.each do |person|
      people_not_picked.push(person) if pickem_count_for_user(user: person) < @game_ids.count
    end

    # send them an email
    notify(people_not_picked)
  end

  private

  def notify(people)
    people.each do |person|
      notification = {
        user: person,
        subject: 'Weekly Pickem Reminder',
        body: "Just a friendly reminder to make this week's pick'em predictions.",
        url: 'https://elliscfb.com'
      }

      # send email
      NotificationMailer.with(notification: notification).email_notification.deliver_later
    end
  end

  def pickem_count_for_user(user:)
    Pickem.where(game: @game_ids).where(user:).count
  end

  def games_for_week
    Game.where("date > ? AND date < ?", @week.start_date, @week.end_date).where(pickem: true).ordered_by_time
  end
end
