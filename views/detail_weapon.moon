import Widget from require "lapis.html"

class DetailWeapon extends Widget
    @include "widgets.helpers"

    content: =>
        h1 class: "detail_title", @item.name

        div class: "detail_picture", ->
            img src: "/static/img/#{@item.text_key}.png"
            span @item.subtype
            span @item.type

        div class: "detail_content_wrapper", ->
            h3 "description"
            div class: "description", -> 
                raw @item.description
            if @item.feature_description != nil then
                h3 class: "special_modifier", "special features"
                p @item.feature_description

            div class: "first fourth container", ->
                h3 "weight"
                @bar_with_label(@to_decimal(@item.weight), 0, 28, 135)

            div class: "fourth container", ->
                h3 "stability"
                @bar_with_label(@to_decimal(@item.stability), 0, 90, 135)

            div class: "fourth container", ->
                h3 "durability"
                @bar_with_label(@item.durability, 0, 999, 135)

            div class: "last fourth container", ->
                h3 "critical"
                @bar_with_label(@item.critical, 0, 160, 135)

            div class: "first third container", ->
                h3 "damage"
                @bar_with_label(@item['physical_damage'], 0, 390, 200, "normal")
                @bar(@item['magic_damage'], 0, 390, 200, "magic")
                @bar(@item['fire_damage'], 0, 390, 200, "fire")
                @bar(@item['lightning_damage'], 0, 390, 200, "lightning")

            div class: "third container", ->
                h3 "reduction"
                @bar_with_label(@item['physical_reduction'], 0, 100, 200, "normal", @item['physical_reduction'].."%")
                @bar(@item['magic_reduction'], 0, 100, 200, "magic", @item['magic_reduction'].."%")
                @bar(@item['fire_reduction'], 0, 100, 200, "fire", @item['fire_reduction'].."%")
                @bar(@item['lightning_reduction'], 0, 100, 200, "lightning", @item['lightning_reduction'].."%")

            div class: "last third container", ->
                h3 "requirements"
                @bar_with_label(@item['strength_required'], 0, 60, 200, "strength")
                @bar(@item['dexterity_required'], 0, 60, 200, "dexterity")
                @bar(@item['intelligence_required'], 0, 60, 200, "intelligence")
                @bar(@item['faith_required'], 0, 60, 200, "faith")

            div class: "first third container", ->
                h3 "auxiliary"
                span class: "min_label", "0"
                span class: "max_label", "500"

                for i in *{'bleed', 'divine', 'occult', 'poison', 'toxic'}
                    match = 0
                    if @item['auxiliary_damages'] != nil
                        for j in *@item['auxiliary_damages']
                            if j['auxiliary_damage_type'] == i then match = j['auxiliary_damage'] 
                    @bar(match, 0, 500, 200, i)

            div class: "third container", ->
                h3 "bonus"
                span class: "min_label", "–"
                span class: "max_label", "s"
                @bar(@item["strength_bonus"], 0, 6, 200, "strength", @table_value_format('strength_bonus', @item["strength_bonus"]))
                @bar(@item["dexterity_bonus"], 0, 6, 200, "dexterity", @table_value_format('dexterity_bonus', @item["dexterity_bonus"]))
                @bar(@item["intelligence_bonus"], 0, 6, 200, "intelligence", @table_value_format('intelligence_bonus', @item["intelligence_bonus"]))
                @bar(@item["faith_bonus"], 0, 6, 200, "faith", @table_value_format('faith_bonus', @item["faith_bonus"]))

            div class: "last third container", ->
                bar_size = (val, div, width) -> 1 + ((val / div) * width)
                h3 "attack type"
                span class: "min_label", "no"
                span class: "max_label", "yes"

                for i in *{'regular', 'strike', 'thrust', 'slash', 'none'}
                    match = 0
                    for j in *@item['attack_types']
                        if j['attack_type'] == i then match = 1

                    span class: "num", style: "margin-left: "..bar_size(match, 1, 200).."px", -> 
                        raw "&nbsp;"
                    div class: "bar", style: "width: "..bar_size(match, 1, 200).."px", ->
                        div class: "bar_background"
                    span i

            h3 "upgrades"

            if @no_upgrades
                p "none"
            else

                if #@results > 5
                    div class: "sticky_weapon_legend quicklinks", ->
                        for i,v in ipairs @results
                            a href: "##{v.upgrade_type}", v.upgrade_type
                            raw " "

                    div class: "sticky_weapon_legend_placeholder", style: "display: none"

                for i,v in ipairs @results
                    div class: "#{@type}_details_upgrade_container clearfix", ->
                        div class: "detailstable clearfix", ->
                            h4 ->
                                span id: "#{v.upgrade_type}",
                                "#{v.upgrade_type}"
                            for i in *@labels
                                span class: "horzlabel", i

                            div class: "svg", ->
                                for f in *@table_keys
                                    if f == 'level' 
                                        continue
                                    span -> img src: "/static/img/labels/"..@replace(f,'_.*', '')..".svg"
                                    raw " "
                            modulo = (num) -> if num % 2 == 0 "even" else "odd"
                            element "table", ->
                                for j=1, #v['upgrades']
                                    tr class: modulo(j-1), ->
                                        u = v['upgrades'][j]
                                        for i in *@table_keys
                                            td @table_value_format i, u[i]

