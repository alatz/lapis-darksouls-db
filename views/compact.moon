import Widget from require "lapis.html"

class Compact extends Widget
    @include "widgets.helpers"

    content: =>

        h1 @display_type

        div class: "linksviewwrapper", ->
            div class: "subheadlinks", ->
                add_select = (str1, str2, classes) -> if str1 == str2 return "selected "..classes
                for v in *@link_names
                    a { 
                        class: add_select(v, @page_type, ""),
                        href: @url_for("compact_index", { type: @type, subtype: v }, sort: "name", order: "asc"),
                        @replace(v, '-', ' ')
                    }
            div class: "subheadviews"

        div class: "subheadfilters", ->
            span "filter: "
            for f in *@filters
                if f == @sort
                    a class: "selected filter", -> 
                        span @replace(f, '_', ' ')
                        div class: "filterimg"

            ul class: "ulfilter", ->
                for f in *@filters
                    li ->
                        a { 
                            href: @url_for("compact_index", { type: @type, subtype: @page_type }, order: "desc", sort: f),
                            @replace(f, '_', ' ')
                        }

        div class: "subheadorders", ->
            span "order: "
            add_select = (str1, str2, classes) -> if str1 == str2 return "selected "..classes
            order_text1, order_text2, order1, order2 = "highest", "lowest", "desc", "asc"
            if @sort == 'name' 
                order_text1, order_text2, order1, order2 = "a-z", "z-a", "asc", "desc"
            a {
                class: add_select(@order, order1, ""),
                href: @url_for("compact_index", { type: @type, subtype: @page_type }, order: order1, sort: @sort),
                order_text1
            }
            a {
                class: add_select(@order, order2, ""),
                href: @url_for("compact_index", { type: @type, subtype: @page_type }, order: order2, sort: @sort),
                order_text2
            }

        div class: "#{@type} stickycontainer #{@type}_stickycontainer clearfix", ->
            for i in *@labels
                span class: "horzlabel", i
                raw " "
            div class: "svg", -> 
                for f in *@filters
                    sel = ""
                    if f != "name"
                        if f == @sort then sel = "_selected"
                        span -> img src: "/static/img/labels/"..@replace(f,'_.*', '')..sel..".svg"
                        raw " "
            div class: "svgabrv", style: "display: none", -> 
                for f in *@filters
                    sel = ""
                    if f != "name"
                        if f == @sort then sel = "_selected"
                        span -> img src: "/static/img/labels/small/"..@replace(f,'_.*', '')..sel..".svg"
                        raw " "

        div class: "stickyplaceholder", style: "display: none"

        element "table", class: "#{@type}table",  ->
            for i,v in ipairs @results
                modulo = (num) -> if num % 2 == 0 "odd" else "even"
                tr class: modulo(i), -> 
                    td -> a href: @url_for("detail_#{@type}", { type: @type, name: v.text_key }), v["name"]
                    for i in *@table_keys
                        td @table_value_format i, v[i]

