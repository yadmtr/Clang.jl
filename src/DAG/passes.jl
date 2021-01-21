abstract type AbstractPass end

mutable struct CollectTopLevelNode <: AbstractPass
    trans_units::Vector{TranslationUnit}
    show_info::Bool
end
CollectTopLevelNode(tus) = CollectTopLevelNode(tus, true)

function (x::CollectTopLevelNode)(dag::ExprDAG)
    for tu in x.trans_units
        tu_cursor = getcursor(tu)
        header_name = spelling(tu_cursor)
        x.show_info &&
            (@info "[CollectTopLevelNode]: processing header: $header_name")
        for cursor in children(tu_cursor)
            collect_top_level_nodes!(dag, cursor)
        end
    end
    return dag
end

const COMPILER_DEFINITIONS_EXTRA = [
    "OBJC_NEW_PROPERTIES",  # https://reviews.llvm.org/D72970
    "_LP64"  # this is a compiler flag and is always defined along with "__LP64__"
]

mutable struct RemoveCompilerDefinition <: AbstractPass
    extra::Vector{String}
    show_info::Bool
end
RemoveCompilerDefinition(show_info) = RemoveCompilerDefinition(COMPILER_DEFINITIONS_EXTRA, show_info)
RemoveCompilerDefinition() = RemoveCompilerDefinition(false)

function (x::RemoveCompilerDefinition)(dag::ExprDAG)
    filter!(dag.nodes) do node
        name = string(node.id)
        if startswith(name, "__") || (name ∈ x.extra)
            x.show_info &&
                (@info "[RemoveCompilerDefinition]: removing $name")
            return false
        else
            return true
        end
    end
    return dag
end

mutable struct ReduceTypedefAnonymousTagType <: AbstractPass
    show_info::Bool
end
ReduceTypedefAnonymousTagType() = ReduceTypedefAnonymousTagType(false)

function (x::ReduceTypedefAnonymousTagType)(dag::ExprDAG)
    len = length(dag.nodes)
    for i = 1:len-1
        cur, next = dag.nodes[i], dag.nodes[i+1]
        is_anonymous(cur) || continue
        is_typedef_elaborated(next) || continue
        refback = children(next.cursor)
        if !isempty(refback) && first(refback) == cur.cursor
            x.show_info &&
                (@info "[ReduceTypedefAnonymousTagType]: adding name $(next.id) to anonymous $(cur.cursor)")
            dag.nodes[i] = ExprNode(next.id, default_type(cur.type), cur.cursor, cur.expr, cur.adj)
            dag.nodes[i+1] = ExprNode(next.id, Removable(), next.cursor, next.expr, next.adj)
        end
    end
    filter!(!is_removable, dag.nodes)
    return dag
end

mutable struct ReduceTypedefAnonymousTagType <: AbstractPass
    show_info::Bool
end
ReduceTypedefAnonymousTagType() = ReduceTypedefAnonymousTagType(false)
