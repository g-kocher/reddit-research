$(function(){
	$('#search-form').submit(function(e){
		e.preventDefault();
		$('#results').html('');
		$("#searching").show();
		var url = "/"+$('input#subreddit').val()+'/'+$('input[name="order"]:checked').val();
		$.get(url, function(data){
			$("#searching").hide();
			$('#results').html(data);
		});

	});
});