$(function() {

    // tabify people/places search and basic/advanced search (respectively)
    $( "#searchNounOption" ).tabs();
    $( "#searchForm" ).tabs();

    // people autocomplete
    $( ".peopleSearch" ).autocomplete({
        source: people,
        minLength: 0,
    }).focus(function(){
        if( this.value == "")
            $(this).trigger('keydown.autocomplete');
    });

    // places autocomplete
    $( ".placesSearch" ).autocomplete({
        source: places,
        minLength: 0,
    }).focus(function(){
        if( this.value == "")
            $(this).trigger('keydown.autocomplete');
    });

    // start year autocomplete
    $( "#yearStart" ).autocomplete({
        source: year,
        minLength: 0,
    }).focus(function(){
        if( this.value == "")
            $(this).trigger('keydown.autocomplete');
    });

    // end year autocomplete
    $( "#yearStop" ).autocomplete({
        source: year,
        minLength: 0,
    }).focus(function(){
        if( this.value == "")
            $(this).trigger('keydown.autocomplete');
    });

    // set the start and end years for the year clue
    $('#exampleYearStart').text(year[0]);
    $('#exampleYearStop').text(year[year.length-1]);

    // set up the check box to filter by works authored by Cody
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

    // check/uncheck all subCategories when a category is checked/unchecked
    $(".category").click(function() {
        var checked = $(this).attr('checked');
        $('.' + $(this).val()).filter('.subCategory').each(function(){
            $(this).attr('checked', checked );
        });
    });

    // if a subCategory is unchecked when the parent category is checked, then 
    // uncheck the parent category
    $('.subCategory').click(function() {
        var subCategory = $(this);
        $('.category').each(function() {
            var category = $(this);
            if( subCategory.hasClass(category.val()) ) {
                if( category.attr('checked') && !subCategory.attr('checked') ) {
                    category.attr('checked', false);
                }
            }
        });
    });
});
