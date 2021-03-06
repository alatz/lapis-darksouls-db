class Helpers

    table_value_format: (key, val) =>
        decimal = (num) -> string.format("%.1f", num)
        bonus = (num) -> 
            lst = { "–", "E", "D", "C", "B", "A", "S" }
            lst[num + 1]
        lookup = {
            level: (x) -> '+'..x, 
            physical_reduction: (x) -> x..'%' ,
            magic_reduction: (x) -> x..'%' ,
            fire_reduction: (x) -> x..'%' ,
            lightning_reduction: (x) -> x..'%' ,
            stability: (x) -> decimal x,
            weight: (x) -> decimal x,
            normal_defense: (x) -> decimal x,
            strike_defense: (x) -> decimal x,
            slash_defense: (x) -> decimal x,
            thrust_defense: (x) -> decimal x,
            magic_defense: (x) -> decimal x,
            fire_defense: (x) -> decimal x,
            lightning_defense: (x) -> decimal x,
            bleed_defense: (x) -> decimal x,
            poison_defense: (x) -> decimal x,
            curse_defense: (x) -> decimal x,
            strength_bonus: (x) -> bonus x, 
            dexterity_bonus: (x) -> bonus x, 
            intelligence_bonus: (x) -> bonus x, 
            faith_bonus: (x) -> bonus x, 
        }
        if lookup[key] != nil then lookup[key](val) else val

    replace: (s, p, r) =>
        str = string.gsub(s, p, r)
        return str

    bar_with_label: (val, min, max, width, name, display) =>
        dec = (num) -> string.format("%.1f", num)
        bar_size = (val, div, width) -> 1 + ((val / div) * width)
        span class: "min_label", "#{min}"
        span class: "max_label", "#{max}"
        span class: "num", style: "margin-left: "..bar_size(val, max, width).."px", if display then display else val
        div class: "bar", style: "width: "..bar_size(val, max, width).."px", ->
            div class: "bar_background"
        if name then span name

    -- add name?
    bar: (val, min, max, width, name, display) =>
        bar_size = (val, div, width) -> 1 + ((val / div) * width)
        span class: "num", style: "margin-left: "..bar_size(val, max, width).."px", if display then display else val
        div class: "bar", style: "width: "..bar_size(val, max, width).."px", ->
            div class: "bar_background"
        if name then span name

    to_decimal: (num) =>
        string.format("%.1f", num)

    static_asset: (url) =>
        config = require("lapis.config").get!
        if config._name == "production"
            "https://s3-us-west-2.amazonaws.com/darksoulsdatabase"..url
        else
            url

