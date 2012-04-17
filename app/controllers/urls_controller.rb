class UrlsController < ApplicationController
  # GET /urls
  # GET /urls.json

  def index
    @urls = Url.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @urls }
    end
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
    @url = Url.find(params[:id])
    max_value = (@url.max_click_nb == 0) ? 1 : @url.max_click_nb
    
    @clicks_chart = Gchart.line(  :size => '550x300', 
              :title => "",
              :bg => {:color => 'AEE9F2'},
              :data => [@url.clicks_in_previous_week.split(",")[6].to_i, @url.clicks_in_previous_week.split(",")[5].to_i, @url.clicks_in_previous_week.split(",")[4].to_i, @url.clicks_in_previous_week.split(",")[3].to_i, @url.clicks_in_previous_week.split(",")[2].to_i, @url.clicks_in_previous_week.split(",")[1].to_i, @url.clicks_in_previous_week.split(",")[0].to_i],
              :line_colors => "00BAD6",
              :axis_with_labels => 'x,y',
              :axis_labels => ['6 days|5 days|4 days|3 days|2 days ago|yesterday|today', "0|#{max_value}"])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @url }
    end
  end

  # GET /urls/new
  # GET /urls/new.json
  def new
    @url = Url.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @url }
    end
  end

  # GET /urls/1/edit
  def edit
    @url = Url.find(params[:id])
  end

  # POST /urls
  # POST /urls.json
  def create
        @url = Url.new(params[:url])
        if @url.is_valid
          url_in_db = Url.find_by_url_in(@url.url_in) 
          if !url_in_db.nil?
            redirect_to :action => "show", :id => url_in_db.id
          else  
            new_url = @url.minimize(8)
            until Url.find_by_url_out(new_url).nil? do
              new_url = @url.minimize(8)
            end
    
            @url.url_out = "http://babyurl.com/#{new_url}"
            @url.out = new_url
            @url.clicks_in_previous_week = "0,0,0,0,0,0,0"
            if @url.save      
              redirect_to :action => "show", :id => @url.id 
            end
          end
        else
          render :nothing => true, :status => 500
        end  
  end

  # PUT /urls/1
  # PUT /urls/1.json
  def update
    @url = Url.find(params[:id])

    respond_to do |format|
      if @url.update_attributes(params[:url])
        format.html { redirect_to @url, notice: 'Url was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url = Url.find(params[:id])
    @url.destroy

    respond_to do |format|
      format.html { redirect_to urls_url }
      format.json { head :no_content }
    end
  end

  def increase_count
    if !params[:id].blank?
      url = Url.find(:first, :conditions => "id = #{params[:id]}")
    end
    if url.nil?
      url = Url.find_by_out(params[:url_out])
    end
    url.click_number = url.click_number + 1
    url.daily_click_number = url.daily_click_number + 1
    week_clicks_array = url.clicks_in_previous_week.split(",")
    week_clicks_array[0] = url.daily_click_number
    url.clicks_in_previous_week = week_clicks_array.join(",")
    url.save
    redirect_to url.url_in  
  end

  def task_save_current_day_clicks  
    urls = Url.all
    urls.each do |url|
      week_click_array = url.clicks_in_previous_week.split(",")
      week_click_array = week_click_array.reverse
      week_click_array.push(0)
      week_click_array.delete_at(0)
      url.clicks_in_previous_week = week_click_array.reverse.join(",")
      url.save
    end
  end
end
