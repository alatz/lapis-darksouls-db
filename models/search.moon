{
    full: {
        query: "
            SELECT 
            *, 
            concat('/detail/',lower(t.type),'/',text_key) as url 
            FROM items i
            INNER JOIN types t ON t.id = i.type
            WHERE i.name ilike ? 
        "
    }
    ajax: {
        query: "
            SELECT 
                name as label, 
                concat('/detail/',lower(t.type),'/',text_key) as value 
            FROM items i
            INNER JOIN types t ON t.id = i.type
            WHERE i.name ilike ? 
            limit 10
        "
    }
}
