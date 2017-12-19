
list_combine = (pt1, pt2) ->
    for l in *pt2
        table.insert(pt1, l) 
    return pt1

list_contains = (str, lst) ->
    match = false
    for i=1, #lst
        if str == lst[i]
            match = true
            break
    return match


{ :list_combine, :list_contains }

