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
    decoded = ActiveSupport::Base64.decode64(payload)
    debugger
    #workaround to avoid the missing '}'
    decoded << '}' if decoded unless decoded[-1]=='}'
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
end
