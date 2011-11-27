// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

lookup = function(fId, friendsList){
  $.ajax(
    {
        type: "POST",
        url: "/users/lookup",
        data: {n_id: $("#n_id").val(),
          uid: fId,//$("#uid").val(),
          friend_list: friendsList},
        success: function(response){
          $("#result_container").html(response.result_html);
          var query = "select uid, name, profile_url from user where uid in ("+response.friend_list+")";
          getData(query, function(friends){
            
            html = ""
            /*
            <div class="friend">
              <a href="JavaScript:void(0);">
                <img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/370567_673863990_1117092293_n.jpg" alt="Hashem Zahran" />
              </a>
            </div><!-- single friend End --> */
            src = ""
            for (var i=0; i< friends.length; i++) {
              html += "<div class='friend'>"
              html += "<a target='_blank' href='"+friends[i].profile_url+"'>"
              html += "<img src='http://graph.facebook.com/"
              html += friends[i].uid + "/picture' title='"+friends[i].name+"'>"
              html += "</a></div>"
            }
            $('#friends_list').html(html)

          });
          if(response.send_request){
            FB.ui({method: 'apprequests',
              message: 'احنا حنصوت مع بعض فى نفس اللجنة !',
              to: response.friend_list
            }, function(){});
          }

          $('body').fadeTo( 'fast', 1);
        }
    });
}
