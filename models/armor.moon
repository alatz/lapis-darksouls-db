{
    details: {
        table_keys: {
            'normal_defense', "strike_defense", "slash_defense", "thrust_defense",
            "magic_defense", "fire_defense", "lightning_defense", "bleed_defense", 
            "poison_defense", "curse_defense",
        }
        labels: {
            'physical def', 'elem def', 'resistance' 
        }
        item_keys_query: {
            "SELECT array_agg(text_key) keys FROM items"
        }
        query: "
            SELECT 
                *
            FROM items i
            INNER JOIN armor_upgrades au ON au.item_id = i.id
            INNER JOIN armor_attributes aa ON aa.item_id = i.id
            LEFT JOIN special_features sf ON sf.item_id = i.id
            WHERE i.text_key = ?
            ORDER BY level
        "
    }
    index: {
        plural: 'Armor'
        orders: {
            "asc", "desc"
        }
        subtypes: {
            'head', 'hand', 'chest', 'leg',
        }
        table_keys: {
            "poise", "durability", "weight",
            'normal_defense', "strike_defense", "slash_defense", "thrust_defense",
            "magic_defense", "fire_defense", "lightning_defense", "bleed_defense", 
            "poison_defense", "curse_defense",
        }
        labels: {
             'physical def', 'elem def', 'resistance' 
        }
        query: "
            SELECT 
                *,
                (SELECT json_agg(DISTINCT text_subtype) 
                FROM items 
                WHERE text_type = 'armor' 
                GROUP BY text_type) as links
            FROM items i
            INNER JOIN armor_upgrades au on au.item_id = i.id
            INNER JOIN armor_attributes aa on aa.item_id = i.id
            WHERE i.text_type = 'armor'
            AND i.text_subtype = ?
            AND au.level = 0
            /* We prevent SQL injection by validating :sort and :order before this.
            :order is guaranteed to be 'asc/desc' and :sort is guaranteed to be in table_keys */
            ORDER BY :sort :order
        "
    }
}
