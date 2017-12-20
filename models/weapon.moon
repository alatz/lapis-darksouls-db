{
    details: {
        table_keys: {
            'level', 'physical_damage', 'magic_damage', 'fire_damage', 'lightning_damage',
            'physical_reduction', 'magic_reduction', 'fire_reduction', 'lightning_reduction',
            'strength_bonus', 'dexterity_bonus', 'intelligence_bonus', 'faith_bonus'
        }
        labels: {
            'damage', 'damage reduction', 'bonus'
        }
        item_keys_query: {
            "SELECT array_agg(text_key) keys FROM items"
        }
        query: "
            SELECT 
                *, 
                text_subtype AS subtype,
                text_type AS type,
                (SELECT json_agg(ad) FROM auxiliary_damages ad WHERE items.id = ad.item_id) auxiliary_damages,
                (SELECT json_agg(aaa) FROM (
                    SELECT * FROM item_attack_types at 
                    INNER JOIN attack_types t ON t.id = at.attack_type_id 
                    WHERE items.id = at.item_id) aaa
                ) attack_types
            FROM (
                SELECT 
                    i.id,
                    upgrade_type,
                    json_agg(wu.*) AS upgrades
                FROM items i
                INNER JOIN weapon_upgrades wu on wu.item_id = i.id
                WHERE i.text_key = ?
                GROUP BY wu.upgrade_type,i.id
            ORDER BY wu.upgrade_type) upgrades 
            INNER JOIN items on upgrades.id = items.id
            INNER JOIN weapon_attributes wa on wa.item_id = items.id
            LEFT JOIN special_features sf on sf.item_id = items.id
        "
        
    }
    index: {
        plural: 'Weapons'
        orders: {
            "asc", "desc"
        }
        subtypes: {
            'axe', 'great-hammer', 'straight-sword', 'thrusting-sword', 'curved-greatsword',
            'spear', 'greatsword', 'bow', 'ultra-greatsword', 'whip', 'crossbow', 'gauntlet',
            'curved-sword', 'greataxe', 'hammer', 'katana', 'halberd', 'dagger',
        }
        table_keys: {
            'durability', 'weight', 'physical_damage', 'magic_damage', 'fire_damage',
            'lightning_damage', 'strength_bonus', 'dexterity_bonus', 'intelligence_bonus',
            'faith_bonus', 'physical_reduction', 'magic_reduction', 'fire_reduction',
            'lightning_reduction',
        }
        labels: {
            'damage', 'bonus', 'reduction'
        }
        query: "
            SELECT 
                *,
                (SELECT json_agg(DISTINCT text_subtype) 
                FROM items 
                WHERE text_type = 'weapon' 
                GROUP BY text_type) AS links
            FROM items i
            INNER JOIN weapon_shield_upgrades w ON w.item_id = i.id
            INNER JOIN requirements r ON r.item_id = i.id
            WHERE i.text_type = 'weapon'
            AND w.upgrade_level_id = 1
            AND w.upgrade_type_id = 1
            AND i.text_subtype = ?
            /* We prevent SQL injection by validating :sort and :order before this.
            :order is guaranteed to be 'asc/desc' and :sort is guaranteed to be in table_keys */
            ORDER BY :sort :order
        "
    }
}
