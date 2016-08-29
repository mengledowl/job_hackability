$(document).on 'turbolinks:load', ->
  $('.chosen-select').chosen({ placeholder_text_multiple: "Filter By" })

  $('.clear-all').click (e)->
    $('#filter-option').find(':input').each (index, element) =>
      $(element).val(null)

    e.preventDefault()
    $('#filter-option').submit()

  $('#filter-option').find(':input').each (index, element) =>
    $(element).change (e)->
      $(e.target).parent().submit()