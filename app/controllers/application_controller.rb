class ApplicationController < ActionController::Base
  include Facebooker2::Rails::Controller
  before_filter :facebook_authorize, :only => :new
  protect_from_forgery
  
  def facebook_authorize
    app_id = FACEBOOK_CONFIG[:app_id]
    canvas_page = FACEBOOK_CONFIG[:canvas_url]
    auth_url = "http://www.facebook.com/dialog/oauth?client_id=#{app_id}&scope=&redirect_uri=#{CGI.escape(canvas_page)}"
    signed_request = params[:signed_request].split(".")
    signature = signed_request[0]
    payload = signed_request[1]
    
    # TODO Authenticate
    # authorize
    #decode the 64 URL
    payload += '=' * (4 - payload.length.modulo(4))
    decoded = Base64.decode64(payload.tr('-_','+/'))

    data = ActiveSupport::JSON.decode(decoded)
    if data['user_id']
      @user_id =  data['user_id']
      @token = data['oauth_token']
    else
      render(:text=>"<script> top.location.href='#{auth_url}'</script>");
      return false
    end
    
     #list($encoded_sig, $payload) = explode('.', $signed_request, 2); 
     #$data = json_decode(base64_decode(strtr($payload, '-_', '+/')), true);
     #if (empty($data["user_id"])) {
     #       echo("<script> top.location.href='" . $auth_url . "'</script>");
     #} else {
     #       echo ("Welcome User: " . $data["user_id"]);
     #}
     
  end

  def get_http(url)
      result = EM::HttpRequest.new(url).get.response
  end

  def get_json( nid )
      result = get_http("http://www.elections2011.eg/proxy.php?type=nid&id=#{nid}")
      body=result[0..(result.index(']'))]+'}'
      lookup_result=JSON.parse(body.gsub(/\(|\)/,''))    
  end
end
