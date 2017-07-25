/*$(function() {
		$( "#searchNounOption" ).tabs();
		$( "#searchForm" ).tabs();
		<!-- $( "#tabs" ).empty(); -->
	
		
	});
	

	
$(function() {
  var peopleTags = people;
		$( ".peopleSearch" ).autocomplete({
			source: peopleTags
		});
});
	
	
$(function() {
  var placesTags = places;
		$( ".placesSearch" ).autocomplete({
			source: placesTags
		});
});

$(function() {
    var authorElement = $("#author");
    if( authorElement != null ) {
        for( var i = 0; i < author.length; i++ ) {
            var index = author[i].indexOf("Cody");
            if( index != -1 ) {
               authorElement.val(author[i]);
               break;
            }
        }
    }
});*/


$(document).ready(function(){
    $("a[rel^='prettyPhoto']").prettyPhoto({
    social_tools: false,
    theme: 'pp_default',
    deeplinking: false
    });
  });
/*
$(document).ready(function(){
    $("body").hide();
  });*/