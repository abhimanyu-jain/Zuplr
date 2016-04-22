$(document).ready ->
  $('nav').affix offset: top: 50
  return

$(document).ready ->
  $('#myCarousel').carousel interval: 4000
  return

$(document).ready ->
  $('#leadform-submit-1').on 'click', (e)->
  	$.ajax
  		url: '/users',
  		method: 'POST',
  		data: {
  			'user[email]': $('#form-name-1').val(),
  			'user[phone]': $('#form-phone-1').val()
  		},
  		success: (data)->
  			$('#form-1').toggle()
  			$('#form-thanks').toggle()
  			window.location.reload()
  		error: (data) ->
  			alert('Failed')
  return

