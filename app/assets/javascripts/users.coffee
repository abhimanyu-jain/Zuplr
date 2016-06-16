# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#add-comment').on 'click', ->
  	$('#comment-form').toggle()
  return

$(document).ready ->
  $('#comment-submit').on 'click', (e)->
  	e.preventDefault()
  	$.ajax 
  	  method: 'POST'
  	  url: '/comments',
  	  data: {
  	  	"comment[user_id]": $('#user-id').val(),
  	  	"comment[remark]": $('#comment-text').val()
  	  },
  	  success: (data) ->
  	  	$('#comment-form').toggle()
  	  	location.reload()
  	  error: (data) ->
  	  	alert 'Update failed'
  return

$('#form_submit').on 'click', (e) ->
  e.preventDefault()
  if $('#user_phone').val().length > 0 and $('#user_city').val().length > 0
    regex_for_phone = /^([0|\+[0-9]{1,5})?([7-9][0-9]{9})$/
    if regex_for_phone.test($('#user_phone').val())
      data = $(':input').serializeArray()
      $.ajax
        url: '/users/new-signup'
        data: data
        method: 'POST'
        success: ->
          $('#new_user').hide()
          $('#message').show()
          return
        error: ->
          console.log 'Error in data angular.isArray(value)ving'
          return
    else
      alert 'Please enter a valid phone number'
  else
    alert 'Please fill all the details'
  return
