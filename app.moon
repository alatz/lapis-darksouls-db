lapis = require "lapis"
db = require "lapis.db"
config = require("lapis.config").get!
models = {
    armor: require 'models.armor'
    weapon: require 'models.weapon'
    shield: require 'models.shield'
    search: require 'models.search'
}
import assert_valid from require "lapis.validate"
import capture_errors, capture_errors_json from require "lapis.application"
import list_combine from require "helpers.lib"

class extends lapis.Application
    views_prefix: "views"
    layout: require "views.default"


    [index: "/"]: => 

        @type = "armor"
        i = models.armor.index
        @display_type, @page_type, @sort, @order = @type, "chest", "name", "asc"
        @labels, @table_keys, @filters = i.labels, i.table_keys, list_combine({'name'}, i.table_keys)

        query = string.gsub(string.gsub(i.query, ':sort', @sort), ':order', @order)
        @results = db.query query, @page_type

        @link_names = @results[1]['links']

        render: "compact"


    [search_ajax: "/search"]: capture_errors {
        on_error: => 
            render: "404", status: 404
        =>
            assert_valid @params, {
                {'term', exists: true, type: "string", max_length: 50 }
            }
            search_term = string.lower(@params.term)
            json: db.query models.search.ajax.query, "%#{search_term}%"
    }

    [search: "/search/full"]: capture_errors {
        on_error: => 
            render: "404", status: 404
        =>
            @title = 'Search'
            assert_valid @params, {
                {'q', exists: true, type: "string", max_length: 50 }
            }

            @search_term = string.lower(@params.q)
            @search_results = db.query models.search.full.query, "%#{@search_term}%"

            render: "search"
    }


    [detail_weapon: "/detail/weapon/:name"]: capture_errors {
        on_error: => 
            render: "404", status: 404
        =>
            @type = 'weapon'
            d = models.weapon.details
            @labels, @table_keys = d.labels, d.table_keys

            items = db.query d.item_keys_query
            assert_valid @params, { { "name", exists: true, one_of: items[1]['keys'] } }

            @results = db.query d.query, @params.name
            @item = @results[1]
            @title = @item.name
            @no_upgrades = @item['upgrades'][2] == nil
            for k,v in pairs @item['upgrades'][1] do @item[k] = v

            render: "detail_weapon"
    }


    [detail_shield: "/detail/shield/:name"]: capture_errors {
        on_error: => 
            render: "404", status: 404
        =>
            @type = "shield"
            d = models.shield.details
            @table_keys, @labels = d.table_keys,d.labels

            items = db.query d.item_keys_query
            assert_valid @params, { { "name", exists: true, one_of: items[1]['keys'] } }

            @results = db.query d.query, @params.name
            @item = @results[1]
            @title = @item.name
            @no_upgrades = @item['upgrades'][2] == nil
            for k,v in pairs @item['upgrades'][1] do @item[k] = v

            render: "detail_weapon"
    }


    [detail_armor: "/detail/armor/:name"]: capture_errors {
        on_error: => 
            render: "404", status: 404
        =>
            @type = 'armor'
            d = models.armor.details
            @table_keys, @labels = d.table_keys, d.labels

            items = db.query d.item_keys_query
            assert_valid @params, { { "name", exists: true, one_of: items[1]['keys'] } }

            @results = db.query d.query, @params.name
            @item = @results[1]
            @title = @item.name

            render: "detail_armor"
    }


    [compact_index: "/compact/:type/:subtype"]: capture_errors {
        on_error: => 
            render: "404", status: 404
        =>
            assert_valid @params, { 
                { "type", exists: true, one_of: { 'armor', 'shield', 'weapon' } } 
            }

            @type = @params.type
            i = models[@type].index

            @page_type, @sort, @order = @params.subtype, @params.sort, @params.order
            @display_type, @table_keys, @labels = i.plural, i.table_keys, i.labels
            @subtypes, @orders, @filters = i.subtypes, i.orders, list_combine({'name'}, @table_keys)
            @title = @display_type

            assert_valid @params, {
                { "sort", exists: true, one_of: @filters }
                { "order", exists: true, one_of: @orders }
                { "subtype", exists: true, one_of: @subtypes }
            }

            query = string.gsub(string.gsub(i.query, ':sort', @sort), ':order', @order) 
            @results = db.query query, @page_type

            @link_names = @results[1]['links']

            render: "compact"
    }


    handle_404: =>
        render: "404"


    handle_error: (err, trace) =>
        if config._name == "production"
            { render: "error" }
        else 
            { super err, trace }

