"""
    collect_top_level_nodes!
To build an expression DAG, we need to collect all of the symbols in advance.
"""
function collect_top_level_nodes! end

function collect_top_level_nodes!(dag::ExprDAG, cursor::CLCursor)
    dumpobj(cursor)
    file, line, col = get_file_line_column(cursor)
    @show file*":$line"
    error()
    return dag
end

function collect_top_level_nodes!(dag::ExprDAG, cursor::CLFunctionDecl)
    func_type = type(cursor)

    if kind(func_type) == CXType_FunctionNoProto
        ty = FunctionNoProto()
    elseif is_variadic(func_type)
        ty = FunctionVariadic()
    elseif kind(func_type) == CXType_FunctionProto
        ty = FunctionProto()
    else
        ty = FunctionNoSupport()
    end

    id = Symbol(spelling(cursor))

    push!(dag.nodes, ExprNode(id, ty, cursor, Expr[], Int[]))

    return dag
end

function collect_top_level_nodes!(dag::ExprDAG, cursor::CLTypedefDecl)
    lhs_type = underlying_type(cursor)

    # in this pass, we only mark those typedefs that point to an elaborated type
    if kind(lhs_type) == CXType_Elaborated
        ty = TypedefElaborated()
    else
        ty = TypedefDefault()
    end

    id = Symbol(spelling(cursor))

    push!(dag.nodes, ExprNode(id, ty, cursor, Expr[], Int[]))

    return dag
end

function collect_top_level_nodes!(dag::ExprDAG, cursor::CLMacroDefinition)
    if is_builtin(cursor)
        ty = MacroBuiltIn()
    elseif is_functionlike(cursor)
        ty = MacroFunctionLike()
    else
        ty = MacroDefault()
    end

    id = Symbol(spelling(cursor))

    push!(dag.nodes, ExprNode(id, ty, cursor, Expr[], Int[]))

    return dag
end

function collect_top_level_nodes!(dag::ExprDAG, cursor::CLStructDecl)
    str = spelling(cursor)

    if isempty(str)
        ty = StructAnonymous()
        id = gensym()
    else
        ty = StructDefault()
        id = Symbol(str)
    end

    push!(dag.nodes, ExprNode(id, ty, cursor, Expr[], Int[]))

    return dag
end

function collect_top_level_nodes!(dag::ExprDAG, cursor::CLUnionDecl)
    str = spelling(cursor)

    if isempty(str)
        ty = UnionAnonymous()
        id = gensym()
    else
        ty = UnionDefault()
        id = Symbol(str)
    end

    push!(dag.nodes, ExprNode(id, ty, cursor, Expr[], Int[]))

    return dag
end

function collect_top_level_nodes!(dag::ExprDAG, cursor::CLEnumDecl)
    str = spelling(cursor)

    if isempty(str)
        ty = EnumAnonymous()
        id = gensym()
    else
        ty = EnumDefault()
        id = Symbol(str)
    end

    push!(dag.nodes, ExprNode(id, ty, cursor, Expr[], Int[]))

    return dag
end

# skip macro expansion since the expanded info is already in the AST
collect_top_level_nodes!(dag::ExprDAG, cursor::CLMacroInstantiation) = dag
collect_top_level_nodes!(dag::ExprDAG, cursor::CLMacroExpansion) = dag
