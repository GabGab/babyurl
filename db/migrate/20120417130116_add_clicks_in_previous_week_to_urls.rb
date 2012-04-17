class AddClicksInPreviousWeekToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :clicks_in_previous_week, :text

  end
end
