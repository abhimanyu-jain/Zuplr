
	function setUserInfo(user_id) {
		$.ajax({
			type : "GET",
			dataType : 'json',
			url : "/userprofiles/" + user_id + ".json",
			data : {

			},
			success : function(obj) {
				phone = obj.phonenumber;
				pincode = obj.pincode;
				address = obj.address;
				$("#input-user-id").val(user_id);
				$("#input-phone").val(phone);
				$("#input-pincode").val(pincode);
				$("#input-address").val(address);
			},
		});

	}

	function update_phone_status(id, val) {
		$.ajax({
			type : "PATCH",
			dataType : 'json',
			url : "/userprofiles/" + id + ".json",
			data : {
				phone_number_status : val
			},
			success : function(result) {
			},
		});
	}

	function update_gender(id, val) {
		$.ajax({
			type : "PATCH",
			dataType : 'json',
			url : "/userprofiles/" + id + ".json",
			data : {
				gender : val
			},
			success : function(result) {
			},
		});
	}

	function update_latest_status(id, val) {
		$.ajax({
			type : "PATCH",
			dataType : 'json',
			url : "/userprofiles/" + id + ".json",
			data : {
				latest_status : val
			},
			success : function(result) {
			},
		});
	}

	function updatestylistcomment(user_id) {
		index = "#stylist-comment" + user_id;
		comment = String($(index).val());
		event.preventDefault();
		$.ajax({
			type : "POST",
			url : "/admin/updateuserstylistcomment",
			data : {
				user_id : user_id,
				stylistcomment : comment
			},
			success : function(result) {
				$(index).val(comment);
			},
		});
	}

	function getStyleData(id, name) {
		$.ajax({
			type : "GET",
			url : "/userprofiles/" + id + ".json",
			data : {
			},
			success : function(result) {
				//val = result.data;
				val = JSON.parse(result.data);
				//alert(val["personal"]["age"]);
				setStyleProfileValues(val);

				//style_profile = JSON.stringify(JSON.parse(val));
				//$("#styleLogPopupStyleInfo").html(style_profile);
				$("#styleLogPopupName").html(name);
			},
		});
	}

	function setStyleProfileValues(val) {
		if(typeof val["personal"] != 'undefined')
		{
			$("#age").html(val["personal"]["age"]);
			$("#height_feet").html(val["personal"]["height"]["feet"]);
			$("#height_inches").html(val["personal"]["height"]["inches"]);
			$("#weight").html(val["personal"]["weight"]);
			$("#bra_size").html(val["personal"]["bra"]["size"]);
			$("#bra_cup").html(val["personal"]["bra"]["cup"]);
			
			if(typeof val["personal"]["size"] != 'undefined')
			{
				$("#size_top").html(val["personal"]["size"]["top"]);
			}
			if(typeof val["personal"]["top"] != 'undefined')
			{
				$("#top_brand").html(val["personal"]["top"]["brand"]);
			}
			
			$("#personal_waist").html(val["personal"]["waist"]);
			$("#hip").html(val["personal"]["hip"]);
			$("#shoulders").html(val["personal"]["shoulders"]);	
		}
		
		if(typeof val["styles"] != 'undefined')
		{
			$("#styles_1").html(val["styles"]["1"]);
			$("#styles_2").html(val["styles"]["2"]);
			$("#styles_3").html(val["styles"]["3"]);
			$("#styles_4").html(val["styles"]["4"]);
			$("#styles_5").html(val["styles"]["5"]);
		}
		
		if(typeof val["lifestyle"] != 'undefined')
		{
			$("#accessory").html(val["lifestyle"]["accessory"]);
			$("#jewellery").html(val["lifestyle"]["jewellery"]);
			$("#lifestyle_accmax").html(val["lifestyle"]["accmax"]);
			$("#lifestyle_accmin").html(val["lifestyle"]["accmin"]);
			$("#materials").html(JSON.stringify(val["lifestyle"]["materials"]));
			$("#colors").html(JSON.stringify(val["lifestyle"]["colors"]));
			$("#prints").html(JSON.stringify(val["lifestyle"]["prints"]));
			$("#intentions").html(JSON.stringify(val["lifestyle"]["intentions"]));
		}
		
		if(typeof val["sociallinks"] != 'undefined')
		{
			$('#pinterest').attr('href', val["sociallinks"]["pinterest"]);
			$('#facebook').attr('href', val["sociallinks"]["facebook"]);
			$('#instagram').attr('href', val["sociallinks"]["instagram"]);
			//$('#pinterest').html(val["sociallinks"]["pinterest"]);
			//$('#facebook').html(val["sociallinks"]["facebook"]);
			//$('#instagram').html(val["sociallinks"]["instagram"]);
		}
	}
