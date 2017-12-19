{
    details: {
        table_keys: {
            'level', 'stability', 'physical_reduction', 'magic_reduction',
            'fire_reduction', 'lightning_reduction', 'physical_damage',
            'magic_damage', 'fire_damage', 'lightning_damage',
            'strength_bonus', 'dexterity_bonus', 'intelligence_bonus',
            'faith_bonus'
        }
        labels: {
             'damage reduction', 'damage', 'bonus' 
        }
        item_keys_query: {
            "SELECT array_agg(text_key) keys FROM items"
        }
        query: "
            SELECT 
                *, 
                text_subtype AS subtype,
                text_type AS type,
                (SELECT json_agg(ad) 
                    FROM auxiliary_damages ad 
                    WHERE items.id = ad.item_id) auxiliary_damages,
                (SELECT json_agg(atc) FROM (
                    SELECT * FROM item_attack_types at 
                    INNER JOIN attack_types t ON t.id = at.attack_type_id 
                    WHERE items.id = at.item_id) atc
                ) attack_types
            FROM (
                SELECT 
                    i.id,
                    upgrade_type,
                    json_agg(wu.*) as upgrades
                FROM items i
                INNER JOIN weapon_upgrades wu on wu.item_id = i.id
                WHERE i.text_key = ?
                GROUP BY wu.upgrade_type,i.id
                ORDER BY wu.upgrade_type
            ) upgrades 
            INNER JOIN items on upgrades.id = items.id
            INNER JOIN weapon_attributes wa on wa.item_id = items.id
            LEFT JOIN special_features sf on sf.item_id = items.id
        "
    }
    index: {
        plural: 'Shields'
        orders: {
            "asc", "desc"
        }
        subtypes: {
            'greatshield', 'medium', 'small',
        }
        table_keys: {
            'durability', 'weight', 'stability', 'physical_reduction', 'magic_reduction',
            'fire_reduction', 'lightning_reduction', 'physical_damage', 'magic_damage',
            'fire_damage', 'lightning_damage', 'strength_bonus', 'dexterity_bonus',
            'intelligence_bonus', 'faith_bonus'
        }
        labels: {
             'damage reduction', 'damage', 'bonus' 
        }
        query: "
            SELECT 
                *,
                (SELECT json_agg(DISTINCT text_subtype) 
                FROM items 
                WHERE text_type = 'shield' 
                GROUP BY text_type) as links
            FROM items i
            INNER JOIN weapon_shield_upgrades w ON w.item_id = i.id
            INNER JOIN requirements r ON r.item_id = i.id
            WHERE i.text_type = 'shield'
            AND w.upgrade_level_id = 1
            AND w.upgrade_type_id = 1
            AND i.text_subtype = ?
            /* We prevent SQL injection by validating :sort and :order before this.
            :order is guaranteed to be 'asc/desc' and :sort is guaranteed to be in table_keys */
            ORDER BY :sort :order
        "
    }
}
