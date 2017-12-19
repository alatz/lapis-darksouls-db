import Widget from require "lapis.html"

class FourOhFour extends Widget
    content: =>
        h1 class: "big", "404"
        h1 class: "small", "page not found"
