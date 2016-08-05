// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


$(document).on('turbolinks:load', function() {
    $(".listing-nav li").click(function() {
        // only activate the clicked tab
        $(this).addClass('active');
        $(".listing-nav li").not(this).removeClass('active');

        // hide everything
        $(".position-description, .comment-container").addClass('hidden');

        // show the correct one
        switch($(this).attr('id')) {
            case 'application-details-tab':
                $(".position-description").removeClass('hidden');
                break;
            case 'comments-tab':
                $(".comment-container").removeClass('hidden');
                break;
            case 'interviews-tab':
                $(".interviews-container").removeClass('hidden');
                break;
        }
    })

});