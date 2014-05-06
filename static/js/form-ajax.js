$('#search-form').submit(function(e){
	e.preventDefault()
	$('#results').html('');
	$('#results').load($('input#subreddit').val()+'/'+$('input[name="order"]:checked').val());
});





/*
$(document).ready(function(){
	jQuery(function($){
		$('#submit').click(function(event) {
			event.preventDefault();
			alert('working')
			$.get('/'+$('input#subreddit').val()+'/'+$('#order').val(), function(data){
				$('#results').html(data);
			}, 'text');
		});
	});
});
*/