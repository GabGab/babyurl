class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.text :url_in
      t.string :url_out
      t.integer :http_status, :default => 301

      t.timestamps
    end
  end
end
