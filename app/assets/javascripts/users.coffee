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