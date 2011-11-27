class HomeController < ApplicationController
  def show
  end

  def debug
    nid=params[:nid]
    render :text=>get_json(nid)
  end

end
