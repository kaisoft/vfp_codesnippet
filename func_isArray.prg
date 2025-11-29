* check variable for find out this is array or hot
* isarray('variable_name') => .T. (Yes) or .F. (No)
FUNCTION IsArray(tcVarName)
    LOCAL lcExpr, lcType
    lcExpr = tcVarName + '[1]'
    lcType = TYPE(lcExpr)
    RETURN (lcType <> 'U')
ENDFUNC
