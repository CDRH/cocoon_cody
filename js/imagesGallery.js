$(function() {
    var rows = parseInt($("#var_rows").val());
    var start = parseInt($("#var_start").val());
    var numFound = parseInt($("#var_numFound").val());

    $('.jumpForm').submit(function(event) {
        var jumpToPage = parseInt($(this).children(".paginationJump").val());

        //make sure the user didn't give us garbage
        if( jumpToPage != null && !isNaN(jumpToPage)) {
            if( rows == null || isNaN(rows) )
                rows = 10;

            var newStart = Math.floor((jumpToPage-1)*rows);

            //edge cases
            if( newStart < 0 )
                newStart = 0;
            if( (newStart) >= numFound )
                newStart = numFound - (numFound%rows);
            if( newStart == numFound )
                newStart -= rows;

            //replace the old start in the new query string
            var startRegex = /start=[0-9]*/ig
            var newStartStr = "start=" + newStart;
            var newQueryString = window.location.search.replace(startRegex, newStartStr );
            if( newQueryString.indexOf(newStartStr) == -1 ) {
                if( newQueryString.indexOf("index.html") == -1 ) {
                    newQueryString += "index.html";
                }
                if( newQueryString.indexOf("?") == -1 ) {
                    newQueryString += "?";
                }
                newQueryString += "&" + newStartStr;
            }
         
            //redirect to new URL
            window.location = window.location.pathname + newQueryString;
        }

        // prevent submit from processing by returning false
        return false;
    });
});
