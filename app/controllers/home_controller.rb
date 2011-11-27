class HomeController < ApplicationController
  def show
  end

  def debug
    nid=params[:nid]
    render :text=>get_http("https://www.elections2011.eg/proxy.php?type=nid&id=#{nid}")
  end

end
