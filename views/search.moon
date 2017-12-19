import Widget from require "lapis.html"

class Search extends Widget
    content: =>
        h1 class: "detail_title", "Search"
        h2 "search term: ", ->
            span class: "highlight", '"'..@search_term..'"'
        ul class: "searchlist", ->
            for s in *@search_results
                li -> a href: s.url, s.name


