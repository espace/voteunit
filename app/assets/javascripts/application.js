// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function (){
  $("#n_id_go").click( function() {
    $('body').fadeTo( 'fast', 0.50);
    $.ajax(
    {
        type: "POST",
        url: "/users/lookup",
        data: {n_id: $("#n_id").val(),
          f_id: 15,//$("#f_id").val(),
          friend_list: "12"},
        success: function(response){
          $("#result_container").html(response.result_html);
          $('body').fadeTo( 'fast', 1);
        }
    });
  });
});

