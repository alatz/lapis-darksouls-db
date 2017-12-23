import Widget from require "lapis.html"

class DetailArmor extends Widget
    @include "widgets.helpers"

    content: =>
        h1 class: "detail_title", @item.name

        div class: "detail_picture", ->
            img src: "/static/img/#{@item.text_key}.png"
            span @item.text_subtype
            span @item.text_type

        div class: "detail_content_wrapper", ->
            h3 "description"
            div class: "description", -> 
                raw @item.description

            if @item.feature_description != nil then
                h3 class: "special_modifier", "special features"
                p @item.feature_description

            div class: "first third container modifier", ->
                h3 "weight"
                @bar_with_label(@to_decimal(@item.weight), 0, 28, 200)

            div class: "third container modifier", ->
                h3 class: "thrid_margin", "poise"
                @bar_with_label(@item.poise, 0, 47, 200)

            div class: "last third container modifier", ->
                h3 "durability"
                @bar_with_label(@item.durability, 0, 999, 200)

            div class: "full container", ->
                h3 "defense"
                span class: "min_label", "0"
                span class: "max_label", "122"
                
                for f in *@table_keys
                    @bar(@item[f], 0, 122, 720, @replace(f,'_.*', ''), @to_decimal(@item[f]))

            h3 "upgrades"

            if @results[2]['normal_defense'] == nil or @results[2]['normal_defense'] == 0
                p "none"
            else
                div class: "armor_details_upgrade_container", ->
                    for i in *@labels
                        span class: "horzlabel", i

                    div class: "svg", ->
                        for f in *@table_keys
                            span -> img src: @static_asset "/static/img/labels/"..@replace(f,'_.*', '')..".svg"
                            raw " "

                    div class: "detailstable", ->
                        modulo = (num) -> if num % 2 == 0 "even" else "odd"
                        element "table", ->
                            for i = 2, #@results
                                tr class: modulo(i), ->
                                    td "+"..i-1
                                    for f in *@table_keys
                                        if @results[i][f] == nil or @results[i][f] == 0
                                            td "0.0"
                                        else 
                                            td @table_value_format f, @results[i][f]
