module ExprDAGs

using ..Clang
using ..Clang.LibClang

include("types.jl")
export AbstractExprNodeType
export AbstractFunctionNodeType, AbstractTypedefNodeType, AbstractMacroNodeType
export AbstractStructNodeType, AbstractUnionNodeType, AbstractEnumNodeType
export ExprNode, ExprDAG

include("passes.jl")
export AbstractPass
export CollectTopLevelNode
export RemoveCompilerDefinition
export ReduceTypedefAnonymousTagType

include("top_level.jl")
export collect_top_level_nodes!

include("deps.jl")
export resolve_deps!

function build!(dag::ExprDAG, passes)
    for pass in passes
        pass(dag)
    end
    return dag
end

end # module
