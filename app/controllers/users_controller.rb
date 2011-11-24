require 'net/http'
require 'net/https'
require "uri"

class UsersController < ApplicationController

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.find_by_uid(@user_id)      
    #@user = User.find_by_uid(@user_id)
    #if @user
    #  @user_exist = true
    #  @ballot = Ballot.find_by_id(@user.ballot_id)
    #  
    #  @all_friends_using_app = User.find_all_by_id(params[:friend_list]).count
    #  @friend_list = User.where(:b_id => @ballot).find_all_by_id(params[:friend_list]).collect { |u| u.uid }
    #  
    #else
    #  @user_exist = false
    #end    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def lookup
    @user = User.find_by_uid(params[:uid])
    new_user = false
    ballot_modified = false
    
    if params[:n_id].present?
      # look up the n_id_go
      result = Net::HTTP.get(URI.parse(" http://pollinglocation.googleapis.com/proxy?nid=#{params[:n_id]}&electionid=2500 "))
      lookup_result = JSON.parse(result)
      if lookup_result["status"] != 'SUCCESS'
        render :json => {
         'success' => false,
         'result_html' => render_to_string(partial: 'invalid_nid.html.erb')
        }
        return
      end
      
      @ballot = Ballot.find_by_code(lookup_result["locations"][0]["code"].to_i)
      unless @ballot.present?
        @ballot = Ballot.new
        @ballot.update_attributes( :code =>  lookup_result["locations"][0]["code"],
         :name => lookup_result["locations"][0]["name"],
         :address => lookup_result["locations"][0]["unparsed_address"],
         :lng => lookup_result["locations"][0]["lng"],
         :lat => lookup_result["locations"][0]["lat"])      
      end
      if @user.present?
        @user.update_attribute( :b_id, @ballot.id ) if ballot_modified = @ballot.id != @user.b_id
      else
        @user = User.new
        @user.update_attributes( :uid =>  params[:uid], :b_id => @ballot.id)
        new_user = true      
      end
      
    else
      @ballot = Ballot.find(@user.b_id)    
    end
    
    friend_ids=params[:friend_list].split(',').collect(&:to_i)
    @all_friends_using_app = User.where(:uid=>friend_ids).count
    @friend_list = User.where(:b_id => @ballot.id, :uid=>friend_ids).collect { |u| u.uid }
    

    render :json => {
       'friend_list' => @friend_list,
       'success' => true,
       'result_html' => render_to_string(partial: 'lookup.html.erb', locals: {no_friends: @friend_list.empty?}),
       'send_request' => (new_user || ballot_modified) && ! @friend_list.blank?
     }     
  end
  
  #######
  private
  #######
  
  
  def delete_request()
    notification_url = "https://graph.facebook.com/apprequests?ids=#{friends.join(",")}&message=#{'hello'}&access_token=#{FACEBOOK_CONFIG[:access_token]}"
    puts "*********************************************************************************** #{notification_url}"
    
    uri = URI.parse(notification_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    
    response = http.request(request)
    
    puts response.body
  end
    
end

