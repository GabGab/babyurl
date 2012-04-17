desc "task that pushes the clicks of a day down the array"
task :save_current_day_clicks => :environment do
  urls = Url.all
  urls.each do |url|
    week_click_array = url.clicks_in_previous_week.split(",")
    week_click_array = week_click_array.reverse
    week_click_array.push(0)
    week_click_array.delete_at(0)
    url.clicks_in_previous_week = week_click_array.reverse.join(",")
    url.daily_click_number = 0
    url.save
  end
end

