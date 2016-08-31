$(document).on 'turbolinks:load', ->
  $('.menu-btn').click (e)->
    $('.menu').toggleClass('open')
    $('.header-cont').toggleClass('open')
    $('#menu-sign-up').toggleClass('sign-up')