class AddClickNumberAndDailyClickNumberToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :click_number, :integer, :default => 0

    add_column :urls, :daily_click_number, :integer, :default => 0

  end
end
