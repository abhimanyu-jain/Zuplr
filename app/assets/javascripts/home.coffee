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
  			console.log("Internal Server Error")
  return


$(document).ready ->
  $('#leadform-submit-1').on 'click', (e) ->
    e.preventDefault()
    if $('#form-name-1').val().length > 0 and $('#form-phone-1').val().length > 0
      regex_for_phone = /^([0|\+[0-9]{1,5})?([7-9][0-9]{9})$/
      regex_for_email = /\S+@\S+\.\S+/
      if regex_for_phone.test($('#form-phone-1').val()) and regex_for_email.test($('#form-name-1').val())
         $.ajax
          url: '/users'
          data:{
            'user[email]': $('#form-name-1').val(),
            'user[phone]': $('#form-phone-1').val()
          },
          method: 'POST'
          success: (data)->
            $('#form-1').toggle()
            $('#form-thanks').toggle()
            window.location.reload()
          error: (data) ->
            console.log("Internal Server Error")
      else
       $(".lead-form-error").show()
    else
      $(".lead-form-error").show()
    return

$(document).ready ->
  $('#leadform-submit-2').on 'click', (e) ->
    e.preventDefault()
    if $('#form-name-2').val().length > 0 and $('#form-phone-2').val().length > 0
      regex_for_phone = /^([0|\+[0-9]{1,5})?([7-9][0-9]{9})$/
      regex_for_email = /\S+@\S+\.\S+/
      if regex_for_phone.test($('#form-phone-2').val()) and regex_for_email.test($('#form-name-2').val())
         $.ajax
          url: '/users'
          data:{
            'user[email]': $('#form-name-2').val(),
            'user[phone]': $('#form-phone-2').val()
          },
          method: 'POST'
          success: (data)->
            $('#form-2').toggle()
            $('#form-thanks').toggle()
            window.location.reload()
          error: (data) ->
            console.log("Internal Server Error")
      else
       $(".lead-form-error").show()
    else
      $(".lead-form-error").show()
    return