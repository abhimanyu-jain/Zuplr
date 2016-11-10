		function updatecomment(order_id) {
				index = "#stylist-comment" + order_id;
				comment = String($(index).val());
				event.preventDefault();
				$.ajax({
					type : "POST",
					url : "/admin/updatecomment",
					data : {
						order_id : order_id,
						stylistcomment : comment
					},
					success : function(result) {
						$(index).val(comment);
					},
				});
			}

			function add_call_note(order_id) {
				note = $("#stylist-call-note" + order_id).val();
				date = $("#next_call_datepicker" + order_id).val();

				event.preventDefault();
				$.ajax({
					type : "POST",
					url : "/admin/next_call",
					data : {
						order_id : order_id,
						stylist_call_note : note,
						next_call_date : date
					},
					success : function(result) {
						location.reload();
					},
				});
			}

			function update_order_status(order_id, status) {
				$.ajax({
					type : "POST",
					url : "/admin/update_order_status",
					data : {
						order_id : order_id,
						order_status : status
					},
					success : function(result) {
						index = "#status" + order_id;
						$(index).html(status);
						location.reload();
					},
				});
			}

			function view_order_status_history(order_id) {
				$.ajax({
					type : "POST",
					url : "/admin/get_order_history",
					contentType : "application/json",
					data : JSON.stringify({
						order_id : order_id
					}),

					success : function(history) {
						$("#order_status_history_info").html('');
						$.each(history, function(i, item) {
							var date = new Date(item["created_at"]);
							d = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear();
							$("#order_status_history_info").append("<tr><td>" + d + "</td><td>" + item["status"] + "</td></tr>");
						});

					},
				});
			}

			function view_contact_history(order_id) {
				$.ajax({
					type : "POST",
					url : "/admin/get_contact_history",
					contentType : "application/json",
					data : JSON.stringify({
						order_id : order_id
					}),

					success : function(history) {
						$("#contact_history_info").html('');
						$.each(history, function(i, item) {
							var date = new Date(item["contact_date"]);
							d = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear();
							$("#contact_history_info").append("<tr><td>" + d + "</td><td>" + item["notes"] + "</td></tr>");
						});

					},
				});
			}
