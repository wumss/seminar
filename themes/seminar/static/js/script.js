/*
Source code from Sebastien Moran at https://gist.github.com/sebz/efddfc8fdcb6b480f567 with minor modifications.
*/

var lunrIndex,
    $results,
    pagesIndex;

// Initialize lunrjs using our generated index file
function initLunr() {
    // First retrieve the index file
    $.getJSON("/seminar/js/lunr/PagesIndex.json")
        .done(function(index) {
            pagesIndex = index;

            // Set up lunrjs by declaring the fields we use
            // Also provide their boost level for the ranking
            lunrIndex = lunr(function() {
                this.field("title", {
                    boost: 10
                });
                this.field("tags", {
                    boost: 5
                });
                this.field("content");

                // ref is the result item identifier (I chose the page URL)
                this.ref("href");
            });

            // Feed lunr with each file and let lunr actually index them
            pagesIndex.forEach(function(page) {
                lunrIndex.add(page);
            });
        })
        .fail(function(jqxhr, textStatus, error) {
            var err = textStatus + ", " + error;
            console.error("Error getting Hugo index flie:", err);
        });
}

// Nothing crazy here, just hook up a listener on the input field
function initUI() {
    $results = $("#results");
    $("#search").keyup(function() {
        console.log("keyup");
        $results.empty();

        // Only trigger a search when 2 chars. at least have been provided
        var query = $(this).val();
        if (query.length < 2) {
          if (query.length == 0) {
            reset();
          }
            return;
        }

        var results = search(query);

        renderResults(results, query);
    });
}

/**
 * Trigger a search in lunr and transform the result
 *
 * @param  {String} query
 * @return {Array}  results
 */
function search(query) {
    // Find the item in our index corresponding to the lunr one to have more info
    // Lunr result:
    //  {ref: "/section/page1", score: 0.2725657778206127}
    // Our result:
    //  {title:"Page1", href:"/section/page1", ...}
    return lunrIndex.search(query).map(function(result) {
            return pagesIndex.filter(function(page) {
                return page.href === result.ref;
            })[0];
        });
}

/**
 * Display the 10 first results
 *
 * @param  {Array} results to display
 */
function renderResults(results, query) {

    $("article").hide();
    $("#clear").show();

    if (!results.length) {
        // reset();
        // return;
        var $result = $("#results");
        $result.append("<p>No results found.</p>");
        return;
    }

    // // Only show the ten first results
    results/*.slice(0, 10)*/.forEach(function(result) {
        var $result = $("<li>");
        $result.append(
          "<a href=seminar" + result.href + ">» " + result.title + "</a>"
          + "<ul><li>" + result.content + "</li></ul>"
        );
        var $li = $result.find("ul > li")
        var html = $li.html();
        var re = new RegExp(query,"gi");
        $li.html(html.replace(re, '<strong>$&</strong>'));
        // $result.append($("<a>", {
        //     href: result.href,
        //     text: "» " + result.title
        // }));
        $results.append($result);
    });

}

// Let's get started
initLunr();

// Toggle methods
function reset() {
  $("article").show();
  $("#clear").hide();
  $("#search").val('');
  $("#results").empty();
}

$(document).ready(function() {
    initUI();

    $("#clear").click(function() {
      $(this).hide();
      reset();
    })
});