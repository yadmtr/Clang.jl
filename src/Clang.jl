module Clang

include("LibClang.jl")
using .LibClang

using DataStructures

include("cltypes.jl")
export CLCursor, CLType, CLToken
foreach(names(@__MODULE__; all=true)) do s
    x = getfield(@__MODULE__, s)
    if x isa DataType && supertype(x) in [CLCursor, CLType, CLToken]
        @eval export $s
    end
end

include("index.jl")
export Index

include("trans_unit.jl")
export TranslationUnit, spelling, getcursor, parse_header, parse_headers

include("cursor.jl")
export is_null, is_decl, is_ref, is_expr, is_stmt, is_attr, has_attr
export is_preprocessing, is_unexposed, is_translation_unit, is_functionlike, is_builtin
export is_inlined, is_bitfield, is_definition, is_variadic, is_typedef_anon
export get_translation_unit, get_semantic_parent, get_lexical_parent, get_included_file
export get_reference, get_definition, get_language
export kind, name, spelling, type, extent, value, location, filename
export canonical, underlying_type, integer_type, get_result_type, return_type, typedef_type
export bitwidth, get_argnum, argument, function_args
export search, children

include("type.jl")
export is_volatile, is_restrict, is_variadic, is_plain_old_data
export address_space, typedef_name, typedecl
export get_pointee_type, get_argtype, get_element_type, get_element_num
export resolve_type, get_named_type
export fields

include("token.jl")
export TokenList, tokenize, annotate

include("utils.jl")
export name_safe, symbol_safe
export copydeps, print_template
export dumpobj
export find_std_headers

include("clang2julia.jl")
export clang2julia, target_type, typesize

include("expr_unit.jl")
export ExprUnit, dump_to_buffer, print_buffer

include("context.jl")
export AbstractContext, DefaultContext
export parse_header!, parse_headers!

include("wrap_c.jl")
export wrap!

include("compat.jl")
export WrapContext, init

function version()
    cxstr = clang_getClangVersion()
    ptr = clang_getCString(cxstr)
    s = unsafe_string(ptr)
    clang_disposeString(cxstr)
    return s
end

const LLVM_VERSION = match(r"[0-9]+.[0-9]+.[0-9]+", version()).match
const LLVM_DIR = normpath(joinpath(dirname(LibClang.Clang_jll.libclang_path), ".."))
const LLVM_LIBDIR = joinpath(LLVM_DIR, "lib")
const LLVM_INCLUDE = joinpath(LLVM_LIBDIR, "clang", LLVM_VERSION, "include")
const CLANG_INCLUDE = LLVM_INCLUDE

export LLVM_VERSION, LLVM_LIBDIR, LLVM_INCLUDE, CLANG_INCLUDE

end
