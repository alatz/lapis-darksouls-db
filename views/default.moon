html = require "lapis.html"

class DefaultLayout extends html.Widget
    @include "widgets.helpers"

    content: =>
        html_5 ->
            head -> 
                meta charset: "utf-8"
                meta "http-equiv": "X-UA-Compatible", content: "IE=edge"
                meta name: "description", content: "A Dark Souls equipment database focused on data visualization."
                meta name: "viewport", content: "width=device-width, initial-scale=1"
                title -> if @title then text "#{@title} - Dark Souls Equipment Database" else text "Dark Souls Equipment Database"
                link rel: "stylesheet", type: "text/css", href: @static_asset "/static/css/normalize.css"
                link rel: "stylesheet", type: "text/css", href: @static_asset "/static/css/main.css"
                link rel: "stylesheet", type: "text/css", href: "https://fonts.googleapis.com/css?family=Cinzel"
                link rel: "stylesheet", type: "text/css", href: "https://fonts.googleapis.com/css?family=Marcellus+SC"
                link rel: "stylesheet", type: "text/css", href: "https://fonts.googleapis.com/css?family=Cinzel+Decorative"

            body -> 
                div class: "wrapper clearfix", ->
                    div class: "header clearfix", ->
                        div class: "leftheader clearfix", ->
                            a class: "logo", alt: "logo", href: @url_for("index")
                        div class: "rightheader clearfix", ->
                            form class: "searchbox clearfix", action: @url_for("search"), ->
                                input { 
                                    class: "searchinput autocomplete", type: "text", 
                                    name: "q", placeholder: "search..." 
                                }
                            div class: "links clearfix", ->
                                ul ->
                                    add_select = (str1, str2, classes) -> if str1 == str2 return "selected "..classes
                                    li -> a class: add_select(@type, "armor", ""), href: @url_for("compact_index", { type: "armor", subtype: "chest"}, sort: "name", order: "asc"), "Armor"
                                    li -> a class: add_select(@type, "weapon", ""), href: @url_for("compact_index", { type: "weapon", subtype: "axe"}, sort: "name", order: "asc"), "Weapons"
                                    li -> a class: add_select(@type, "shield", ""), href: @url_for("compact_index", { type: "shield", subtype: "greatshield"}, sort: "name", order: "asc"), "Shields"

                    @content_for "inner"
                    @content_for "footer"
                    @content_for "footer2"
                    div class: "footer", ->
                        script src: "https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"
                        script src: "https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"
                        script src: @static_asset "/static/js/main.js"

                    ----todo: uncomment
                    --raw [[
                        --<!--Google analytics-->
                        --<script>
                            --(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                                --(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                                    --m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                              --})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
                              --ga('create', 'UA-48161423-1', 'darksoulsdatabase.com');
                              --ga('send', 'pageview');
                        --</script>
                        --]]
