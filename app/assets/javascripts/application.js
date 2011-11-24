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
          f_id: fId,//$("#f_id").val(),
          friend_list: friendsList},
        success: function(response){
          $("#result_container").html(response.result_html);
          // TODO Get friends names
          friends = []
          for (var i=0; i< friends.length; i++) {
            $('#friend_list').html($('#friend_list').html()+"<li>"+ friends[i] +"<li/>")
          }
          $('body').fadeTo( 'fast', 1);
        }
    });
}