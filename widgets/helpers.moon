class Helpers

    table_value_format: (key, val) =>
        decimal = (num) -> string.format("%.1f", num)
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

