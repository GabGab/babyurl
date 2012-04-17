class AddOutToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :out, :text

  end
end
