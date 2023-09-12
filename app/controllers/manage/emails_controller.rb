class Manage::EmailsController < Manage::ApplicationController
  def send_weekly_reminder
    begin
      today = Date.today
      week = Week.where("start_date <= ? AND end_date >= ?", today, today).first

      WeeklyEmailReminder.call(week)

      render json: { success: true }, status: :ok
    rescue => exception
      render json: { error: exception }, status: 500
    end
  end
end
