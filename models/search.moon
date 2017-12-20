{
    full: {
        query: "
            SELECT 
            *, 
            concat('/detail/',lower(t.type),'/',text_key) AS url 
            FROM items i
            INNER JOIN types t ON t.id = i.type
            WHERE i.name ilike ? 
        "
    }
    ajax: {
        query: "
            SELECT 
                name AS label, 
                concat('/detail/',lower(t.type),'/',text_key) AS value 
            FROM items i
            INNER JOIN types t ON t.id = i.type
            WHERE i.name ilike ? 
            LIMIT 10
        "
    }
}
