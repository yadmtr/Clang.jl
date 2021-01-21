"""
    abstract expression node type
"""
abstract type AbstractExprNodeType end

struct Removable <: AbstractExprNodeType end

"""
    abstract expression node type for function decls
"""
abstract type AbstractFunctionNodeType <: AbstractExprNodeType end

struct FunctionProto <: AbstractFunctionNodeType end
struct FunctionNoProto <: AbstractFunctionNodeType end
struct FunctionVariadic <: AbstractFunctionNodeType end
struct FunctionNoSupport <: AbstractFunctionNodeType end

"""
    abstract expression node type for typedef decls
"""
abstract type AbstractTypedefNodeType <: AbstractExprNodeType end

struct TypedefElaborated <: AbstractTypedefNodeType end
struct TypedefAnonymous <: AbstractTypedefNodeType end
struct TypedefDefault <: AbstractTypedefNodeType end

"""
    abstract expression node type for typedef decls
"""
abstract type AbstractMacroNodeType <: AbstractExprNodeType end

struct MacroFunctionLike <: AbstractMacroNodeType end
struct MacroBuiltIn <: AbstractMacroNodeType end
struct MacroDefault <: AbstractMacroNodeType end

"""
    abstract expression node type for struct decls
"""
abstract type AbstractStructNodeType <: AbstractExprNodeType end

struct StructAnonymous <: AbstractStructNodeType end
struct StructForwardDecl <: AbstractStructNodeType end
struct StructDefault <: AbstractStructNodeType end

"""
    abstract expression node type for union decls
"""
abstract type AbstractUnionNodeType <: AbstractExprNodeType end

struct UnionAnonymous <: AbstractUnionNodeType end
struct UnionForwardDecl <: AbstractUnionNodeType end
struct UnionDefault <: AbstractUnionNodeType end

"""
    abstract expression node type for enum decls
"""
abstract type AbstractEnumNodeType <: AbstractExprNodeType end

struct EnumAnonymous <: AbstractEnumNodeType end
struct EnumForwardDecl <: AbstractEnumNodeType end
struct EnumDefault <: AbstractEnumNodeType end


"""
    struct ExprNode{T<:AbstractExprNodeType,S<:CLCursor}
An expression node in the expression DAG.
"""
struct ExprNode{T<:AbstractExprNodeType,S<:CLCursor}
    id::Symbol
    type::T
    cursor::S
    expr::Vector{Expr}
    adj::Vector{Int}
end

struct ExprDAG
    nodes::Vector{ExprNode}
end


# helper functions
is_removable(::ExprNode{T,S}) where {T<:AbstractExprNodeType,S<:CLCursor} = T <: Removable

is_anonymous(::ExprNode{T,S}) where {T<:AbstractExprNodeType,S<:CLCursor} =
    T <: Union{StructAnonymous,UnionAnonymous,EnumAnonymous}

default_type(type::AbstractTypedefNodeType) = TypedefDefault()
default_type(type::AbstractMacroNodeType) = MacroDefault()
default_type(type::AbstractStructNodeType) = StructDefault()
default_type(type::AbstractUnionNodeType) = UnionDefault()
default_type(type::AbstractEnumNodeType) = EnumDefault()

is_typedef_elaborated(::ExprNode{T,S}) where {T<:AbstractExprNodeType,S<:CLCursor} =
    T <: TypedefElaborated
