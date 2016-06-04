# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#submission').on 'click', (e)->
  	$.ajax
  		url: '/orders',
  		method: 'POST',
  		data : {},
  		success: (data)->
  			$('#submission').toggle()
  			$('#confirm-submission').toggle()
  			
  		error: (data) ->
  			console.log("Internal Server Error")
  return