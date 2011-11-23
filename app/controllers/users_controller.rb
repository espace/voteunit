class UsersController < ApplicationController

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

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
    # look up the n_id_go
    require 'net/http'
    result = Net::HTTP.get(URI.parse(" http://pollinglocation.googleapis.com/proxy?nid=#{params[:n_id]}&electionid=2500 "))
    lookup_result = JSON.parse(result)
    puts "**********************************"
    puts "**********************************"
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
    @user = User.find_by_f_id(params[:f_id])
    if @user.present?
      @user.update_attribute( :b_id, @ballot.id )
    else
      @user = User.new
      @user.update_attributes( :f_id =>  params[:f_id], :b_id => @ballot.id)      
    end
    
    @all_friends_using_app = User.find_all_by_id(params[:friend_list]).count
    @friend_list = User.where(:b_id => @ballot).find_all_by_id(params[:friend_list]).collect { |u| u.f_id }
    render :json => {
       'friend_list' => @friend_list,
       'success' => true,
       'result_html' => render_to_string(partial: 'lookup.html.erb', locals: { no_friends: @friend_list.empty? })
     } 
    
    
  end
    
end
