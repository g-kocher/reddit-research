$('#submit').click(function(event){
	$('#results').html($.get('/'+$('input#subreddit').val()+'/'+$('#order').val()))
})





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