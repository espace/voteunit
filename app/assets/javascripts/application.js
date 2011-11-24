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
          // TODO Get friends names
          var query = "select username, profile_url from user where uid in ("+response.friend_list+")";
          getData(query, function(friends){
            html = ""
            for (var i=0; i< friends.length; i++) {
              html += "<li><a href='"+ friends[i].profile_url +"'>"+ friends[i].username +"</a></li>"
            }
            $('#friends_list').html(html)
          });

          $('body').fadeTo( 'fast', 1);
        }
    });
}
