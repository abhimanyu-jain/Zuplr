function cancel_order(order_id, status) {
	$.ajax({
		type : "POST",
		url : "/orders/update_status",
		data : {
			order_id : order_id,
			order_status : status
		},
		success : function(result) {
			location.reload();
		},
	});
}
