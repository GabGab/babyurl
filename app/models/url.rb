class Url < ActiveRecord::Base
  require 'open-uri'
  validates :url_in, :uniqueness => true

  def minimize target_length
    rand(36**target_length).to_s(36)
  end

  def is_valid
    begin 
      open self.url_in
      return true
    rescue
      return false
    end   
  end

  def max_click_nb
    self.clicks_in_previous_week.split(",").max.to_i 
  end
end
