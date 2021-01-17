"""
    is_null(c::Union{CXCursor,CLCursor}) -> Bool
Return true if cursor is null.
Wrapper for libclang's `clang_Cursor_isNull`.
"""
is_null(c::Union{CXCursor,CLCursor}) = clang_Cursor_isNull(c) != 0

"""
    get_null_cursor() -> CXCursor
Return the "NULL" CXCursor.
Wrapper for libclang's `clang_getNullCursor`.
"""
get_null_cursor() = clang_getNullCursor()

# equality
Base.:(==)(c1::CXCursor, c2::CXCursor)::Bool = clang_equalCursors(c1, c2)
Base.hash(c::CXCursor) = clang_hashCursor(c)

"""
    kind(c::CXCursor) -> CXCursorKind
Return the kind of the given cursor.
Wrapper for libclang's `clang_getCursorKind`.
"""
kind(c::CXCursor) = clang_getCursorKind(c)

"""
    kind(c::CLCursor) -> CXCursorKind
Return the kind of the given cursor.
Note this method directly reads CXCursor's `kind` field, which won't invoke additional
`clang_getCursorKind` function calls.
"""
kind(c::CLCursor) = c.cursor.kind

"""
    is_decl(k::CXcursorKind) -> Bool
    is_decl(c::CLCursor) -> Bool
Return true if the given cursor kind represents a declaration.
Wrapper for libclang's `clang_isDeclaration`.
"""
is_decl(k::CXCursorKind)::Bool = clang_isDeclaration(k)
is_decl(c::CLCursor) = is_decl(kind(c))

"""
    is_ref(k::CXcursorKind) -> Bool
    is_ref(c::CLCursor) -> Bool
Return true if the given cursor kind represents a simple reference. Note that other kinds of
cursors (such as expressions) can also refer to other cursors. Use [`get_reference`](@ref) to determine
whether a particular cursor refers to another entity.
Wrapper for libclang's `clang_isReference`.
"""
is_ref(k::CXCursorKind)::Bool = clang_isReference(k)
is_ref(c::CLCursor) = is_ref(kind(c))

"""
    is_expr(k::CXcursorKind) -> Bool
    is_expr(c::CLCursor) -> Bool
Return true if the given cursor kind represents an expression.
Wrapper for libclang's `clang_isExpression`.
"""
is_expr(k::CXCursorKind)::Bool = clang_isExpression(k)
is_expr(c::CLCursor) = is_expr(kind(c))

"""
    is_stmt(k::CXcursorKind) -> Bool
    is_stmt(c::CLCursor) -> Bool
Return true if the given cursor kind represents a statement.
Wrapper for libclang's `clang_isStatement`.
"""
is_stmt(k::CXCursorKind)::Bool = clang_isStatement(k)
is_stmt(c::CLCursor) = isstat(kind(c))

"""
    is_attr(k::CXcursorKind) -> Bool
    is_attr(c::CLCursor) -> Bool
Return true if the given cursor kind represents an attribute.
Wrapper for libclang's `clang_isAttribute`.
"""
is_attr(k::CXCursorKind)::Bool = clang_isAttribute(k)
is_attr(c::CLCursor) = is_attr(kind(c))

"""
    has_attr(c::Union{CXCursor,CLCursor}) -> Bool
Determine whether the given cursor has any attributes.
Wrapper for libclang's `clang_Cursor_hasAttrs`.
"""
has_attr(c::Union{CXCursor,CLCursor})::Bool = clang_Cursor_hasAttrs(c)

"""
    is_valid(k::CXcursorKind) -> Bool
    is_valid(c::CLCursor) -> Bool
Return true if the given cursor kind represents an valid cursor.
Wrapper for libclang's `clang_isInvalid`.
"""
is_valid(k::CXCursorKind) = !(Bool(clang_isInvalid(k)))
is_valid(c::CLCursor) = is_valid(kind(c))

"""
    is_translation_unit(k::CXcursorKind) -> Bool
    is_translation_unit(c::CLCursor) -> Bool
Return true if the given cursor kind represents a translation unit.
Wrapper for libclang's `clang_isTranslationUnit`.
"""
is_translation_unit(k::CXCursorKind)::Bool = clang_isTranslationUnit(k)
is_translation_unit(c::CLCursor) = is_translation_unit(kind(c))

"""
    is_preprocessing(k::CXcursorKind) -> Bool
    is_preprocessing(c::CLCursor) -> Bool
Return true if the given cursor kind represents a preprocessing element, such as a
preprocessor directive or macro instantiation.
Wrapper for libclang's `clang_isPreprocessing`.
"""
is_preprocessing(k::CXCursorKind)::Bool = clang_isPreprocessing(k)
is_preprocessing(c::CLCursor) = is_preprocessing(kind(c))

"""
    is_unexposed(k::CXcursorKind) -> Bool
Return true if the given cursor kind represents a currently unexposed piece of the AST
(e.g., CXCursor_UnexposedStmt).
Wrapper for libclang's `clang_isUnexposed`.
"""
is_unexposed(k::CXCursorKind)::Bool = clang_isUnexposed(k)
is_unexposed(c::CLCursor) = is_unexposed(kind(c))

"""
    get_linkage(c::Union{CXCursor,CLCursor}) -> CXLinkageKind
Return the linkage of the entity referred to by a given cursor.
Wrapper for libclang's `clang_getCursorLinkage`.
"""
get_linkage(c::Union{CXCursor,CLCursor})::CXLinkageKind = clang_getCursorLinkage(c)

## TODO:
# clang_getCursorVisibility
# clang_getCursorAvailability
# clang_getCursorPlatformAvailability
# clang_disposeCXPlatformAvailability

"""
    get_language(c::Union{CXCursor,CLCursor}) -> CXLanguageKind
Return the language of the entity referred to by a given cursor.
Return `CXLanguage_Invalid` if the input cursor is not a decl.
Note that, this function has limitations, for example, it cannot distinguish C++ structs
from C structs, in both cases, it returns `CXLanguage_C`.
Wrapper for libclang's `clang_getCursorLanguage`.
"""
get_language(c::Union{CXCursor,CLCursor})::CXLanguageKind = clang_getCursorLanguage(c)

# clang_getCursorTLSKind

"""
    get_translation_unit(c::Union{CXCursor,CLCursor}) -> CXTranslationUnit
Returns the translation unit that a cursor originated from.
Wrapper for libclang's `clang_Cursor_getTranslationUnit`.
"""
get_translation_unit(c::Union{CXCursor,CLCursor}) = clang_Cursor_getTranslationUnit(c)

## TODO: this is mainly for internal debugging?
# clang_createCXCursorSet
# clang_disposeCXCursorSet
# clang_CXCursorSet_contains
# clang_CXCursorSet_insert

"""
    get_semantic_parent(c::CXCursor) -> CXCursor
    get_semantic_parent(c::CLCursor) -> CLCursor
Return the semantic parent of the given cursor. Please checkout libclang's doc to know more.
Wrapper for libclang's `clang_getCursorSemanticParent`.
"""
get_semantic_parent(c::CXCursor) = clang_getCursorSemanticParent(c)
get_semantic_parent(c::CLCursor)::CLCursor = clang_getCursorSemanticParent(c)

"""
    get_lexical_parent(c::CXCursor) -> CXCursor
    get_lexical_parent(c::CLCursor) -> CLCursor
Return the lexical parent of the given cursor. Please checkout libclang's doc to know more.
Wrapper for libclang's `clang_getCursorLexicalParent`.
"""
get_lexical_parent(c::CXCursor) = clang_getCursorLexicalParent(c)
get_lexical_parent(c::CLCursor)::CLCursor = clang_getCursorLexicalParent(c)

## TODO:
# clang_getOverriddenCursors
# clang_disposeOverriddenCursors

"""
    get_included_file(c::Union{CXCursor,CLCursor}) -> CXFile
Return the file that is included by the given inclusion directive cursor.
Wrapper for libclang's `clang_getIncludedFile`.
"""
get_included_file(c::Union{CXCursor,CLCursor}) = clang_getIncludedFile(c)

"""
    location(c::Union{CXCursor,CLCursor}) -> CXSourceLocation
Return the physical location of the source constructor referenced by the given cursor.
Wrapper for libclang's `clang_getCursorLocation`.
"""
location(c::Union{CXCursor,CLCursor}) = clang_getCursorLocation(c)

"""
    extent(c::Union{CXCursor,CLCursor}) -> CXSourceRange
Return the physical extent of the source construct referenced by the given cursor.

The extent of a cursor starts with the file/line/column pointing at the first character
within the source construct that the cursor refers to and ends with the last character
within that source construct. For a declaration, the extent covers the declaration itself.
For a reference, the extent covers the location of the reference (e.g., where the referenced
entity was actually used).
Wrapper for libclang's `clang_getCursorExtent`.
"""
extent(c::Union{CXCursor,CLCursor}) = clang_getCursorExtent(c)

"""
    type(c::CXCursor) -> CXType
    type(c::CLCursor) -> CLType
Return the type of a CXCursor (if any). To get the cursor from a type, see [`typedecl`](@ref).
Wrapper for libclang's `clang_getCursorType`.
"""
type(c::CXCursor) = clang_getCursorType(c)
type(c::CLCursor)::CLType = clang_getCursorType(c)

"""
    underlying_type(c::CLTypedefDecl) -> CLType
Return the underlying type of a typedef declaration.
Wrapper for libclang's `clang_getTypedefDeclUnderlyingType`.
"""
underlying_type(c::CXCursor) = clang_getTypedefDeclUnderlyingType(c)
underlying_type(c::CLTypedefDecl)::CLType = clang_getTypedefDeclUnderlyingType(c)

"""
    integer_type(c::CLEnumDecl) -> CLType
Retrieve the integer type of an enum declaration.
Wrapper for libclang's `clang_getEnumDeclIntegerType`.
"""
integer_type(c::CXCursor) = clang_getEnumDeclIntegerType(c)
integer_type(c::CLEnumDecl)::CLType = clang_getEnumDeclIntegerType(c)

"""
    value(c::CLCursor) -> Int
Return the integer value of an enum constant declaration.
"""
function value(c::CLEnumConstantDecl)::Int
    typeKind = kind(type(c))
    if typeKind == CXType_Int || typeKind == CXType_Long || typeKind == CXType_LongLong
        return clang_getEnumConstantDeclValue(c)
    elseif typeKind == CXType_UInt ||
           typeKind == CXType_ULong ||
           typeKind == CXType_ULongLong
        return clang_getEnumConstantDeclUnsignedValue(c)
    end
    return error("Unknown EnumConstantDecl type: ", typeKind, " cursor: ", kind(c))
end

"""
    bitwidth(c::CLFieldDecl) -> Int
Return the bit width of a bit field declaration as an integer.
Wrapper for libclang's `clang_getFieldDeclBitWidth`.
"""
bitwidth(c::CXCursor)::Int = clang_getFieldDeclBitWidth(c)
bitwidth(c::CLFieldDecl) = clang_getFieldDeclBitWidth(c)

"""
    get_argnum(c::Union{CXCursor,CLFunctionDecl,CLCXXMethod}) -> Int
Return the number of non-variadic arguments associated with a given cursor.
Wrapper for libclang's `clang_Cursor_getNumArguments`.
"""
get_argnum(c::Union{CXCursor,CLFunctionDecl,CLCXXMethod})::Int = clang_Cursor_getNumArguments(c)

"""
    argument(c::CXCursor, i::Integer) -> CXCursor
    argument(c::Union{CLFunctionDecl,CLCXXMethod}, i::Integer) -> CLCursor
Return the argument cursor of a function or method.
Wrapper for libclang's `clang_Cursor_getArgument`.
"""
argument(c::CXCursor, i::Integer) = clang_Cursor_getArgument(c, Unsigned(i))
argument(c::Union{CLFunctionDecl,CLCXXMethod}, i::Integer)::CLCursor =
    clang_Cursor_getArgument(c, Unsigned(i))

## TODO:
# clang_Cursor_getNumTemplateArguments
# clang_Cursor_getTemplateArgumentKind
# clang_Cursor_getTemplateArgumentType
# clang_Cursor_getTemplateArgumentValue
# clang_Cursor_getTemplateArgumentUnsignedValue

"""
    is_functionlike(c::Union{CXCursor,CLCursor}) -> Bool
Determine whether a CXCursor that is a macro, is function like.
Wrapper for libclang's `clang_Cursor_isMacroFunctionLike`.
"""
is_functionlike(c::Union{CXCursor,CLCursor})::Bool = clang_Cursor_isMacroFunctionLike(c)

"""
    is_builtin(c::Union{CXCursor,CLCursor}) -> Bool
Determine whether a  CXCursor that is a macro, is a builtin one.
Wrapper for libclang's `clang_Cursor_isMacroBuiltin`.
"""
is_builtin(c::Union{CXCursor,CLCursor})::Bool = clang_Cursor_isMacroBuiltin(c)

"""
    is_inlined(c::Union{CXCursor,CLCursor}) -> Bool
Determine whether a CXCursor that is a function declaration, is an inline declaration.
Wrapper for libclang's `clang_Cursor_isFunctionInlined`.
"""
is_inlined(c::Union{CXCursor,CLCursor})::Bool = clang_Cursor_isFunctionInlined(c)

"""
    get_result_type(c::CXCursor) -> CXType
    get_result_type(c::Union{CLFunctionDecl,CLCXXMethod}) -> CLType
Return the return type associated with a given cursor. This only returns a valid type if
the cursor refers to a function or method.
Wrapper for libclang's `clang_getCursorResultType`.
"""
get_result_type(c::CXCursor) = clang_getCursorResultType(c)
get_result_type(c::Union{CLFunctionDecl,CLCXXMethod})::CLType = clang_getCursorResultType(c)

## TODO:
# clang_getCursorExceptionSpecificationType
# clang_Cursor_getOffsetOfField
#

"""
    is_anonymous(c::Union{CXCursor,CLCursor}) -> Bool
Return true if the given cursor represents an anonymous record declaration(C++).
Wrapper for libclang's `clang_Cursor_isAnonymous`.
"""
is_anonymous(c::Union{CXCursor,CLCursor})::Bool = clang_Cursor_isAnonymous(c)

"""
    is_bitfield(c::Union{CXCursor,CLCursor}) -> Bool
Return true if the cursor specifies a Record member that is a bitfield.
Wrapper for libclang's `clang_Cursor_isBitField`.
"""
is_bitfield(c::Union{CXCursor,CLCursor}) = clang_Cursor_isBitField(c) != 0

"""
    is_virtual_base(c::Union{CXCursor,CLCursor}) -> Bool
Return true if the base class specified by the cursor with kind CX_CXXBaseSpecifier is virtual.
Wrapper for libclang's `clang_isVirtualBase`.
"""
is_virtual_base(c::Union{CXCursor,CLCursor})::Bool = clang_isVirtualBase(c)

## TODO:
# clang_getCXXAccessSpecifier
# clang_Cursor_getStorageClass
# clang_getNumOverloadedDecls
# clang_getOverloadedDecl
# clang_getIBOutletCollectionType
#

"""
    spelling(c::Union{CXCursor,CLCursor}) -> String
Return a name for the entity referenced by this cursor.
"""
function spelling(c::Union{CXCursor,CLCursor})
    cxstr = clang_getCursorSpelling(c)
    ptr = clang_getCString(cxstr)
    s = unsafe_string(ptr)
    clang_disposeString(cxstr)
    return s
end

# clang_Cursor_getSpellingNameRange

"""
    name(c::Union{CXCursor,CLCursor}) -> String
Return the display name for the entity referenced by this cursor.
"""
function name(c::Union{CXCursor,CLCursor})
    cxstr = clang_getCursorDisplayName(c)
    ptr = clang_getCString(cxstr)
    s = unsafe_string(ptr)
    clang_disposeString(cxstr)
    return s
end

"""
    get_reference(c::CXCursor) -> CXCursor
    get_reference(c::CLCursor) -> CLCursor
For a cursor that is a reference, retrieve a cursor representing the entity that it references.
Wrapper for libclang's `clang_getCursorReferenced`.
"""
get_reference(c::CXCursor) = clang_getCursorReferenced(c)
get_reference(c::CLCursor)::CLCursor = clang_getCursorReferenced(c)

"""
    get_definition(c::CXCursor) -> CXCursor
    get_definition(c::CLCursor) -> CLCursor
For a cursor that is either a reference to or a declaration of some entity, retrieve a cursor
that describes the definition of that entity.
Wrapper for libclang's `clang_getCursorDefinition`.
"""
get_definition(c::CXCursor) = clang_getCursorDefinition(c)
get_definition(c::CLCursor)::CLCursor = clang_getCursorDefinition(c)

"""
    is_definition(c::Union{CXCursor,CLCursor}) -> Bool
Return true if the declaration pointed to by this cursor is also a definition of that entity.
Wrapper for libclang's `clang_isCursorDefinition`.
"""
is_definition(c::Union{CXCursor,CLCursor})::Bool = clang_isCursorDefinition(c)

"""
    canonical(c::CXCursor) -> CXCursor
    canonical(c::CLCursor) -> CLCursor
Return the canonical cursor corresponding to the given cursor.
Wrapper for libclang's `clang_getCanonicalCursor`.
"""
canonical(c::CXCursor) = clang_getCanonicalCursor(c)
canonical(c::CLCursor)::CLCursor = clang_getCanonicalCursor(c)

## TODO:
# clang_Cursor_getObjCSelectorIndex
# clang_Cursor_isDynamicCall
# clang_Cursor_getReceiverType

"""
    is_variadic(c::Union{CXCursor,CLCursor}) -> Bool
Return true if the given cursor is a variadic function or method.
Wrapper for libclang's `clang_Cursor_isVariadic`.
"""
is_variadic(c::Union{CXCursor,CLCursor}) = clang_Cursor_isVariadic(c) != 0

# clang_Cursor_isExternalSymbol
# clang_Cursor_getCommentRange
# clang_Cursor_getRawCommentText
# clang_Cursor_getBriefCommentText

function spelling(k::CXCursorKind)
    cxstr = clang_getCursorKindSpelling(k)
    ptr = clang_getCString(cxstr)
    s = unsafe_string(ptr)
    clang_disposeString(cxstr)
    return s
end

# helper
"""
    filename(c::Union{CXCursor,CLCursor}) -> String
Return the complete file and path name of the given file referenced by the input cursor.
"""
function filename(c::Union{CXCursor,CLCursor})
    file = Ref{CXFile}(C_NULL)
    line = Ref{Cuint}(0)
    column = Ref{Cuint}(0)
    offset = Ref{Cuint}(0)
    location = clang_getCursorLocation(c)
    clang_getExpansionLocation(location, file, line, column, offset)
    if file[] != C_NULL
        cxstr = clang_getFileName(file[])
        ptr = clang_getCString(cxstr)
        s = unsafe_string(ptr)
        clang_disposeString(cxstr)
        return s
    else
        return ""
    end
end

"""
    return_type(c::CLCursor, resolve::Bool=true) -> CXType
Return the return type associated with a function/method cursor.
"""
function return_type(c::CLCursor, resolve::Bool=true)
    t = get_result_type(c)
    resolve && return resolve_type(t)
    return t
end

"""
    typedef_type(c::CLCursor) -> CXType
Return the underlying type of a typedef declaration.
"""
function typedef_type(c::CLCursor)
    t = underlying_type(c)
    kind(t) == CXType_Unexposed && return type(children(c)[1])
    return t
end

"""
    search(cursors::Vector{CLCursor}, ismatch::Function) -> Vector{CLCursor}
Return vector of CLCursors that match predicate. `ismatch` is a function that accepts a CLCursor argument.
"""
function search(cursors::Vector{T}, ismatch::Function) where {T<:CLCursor}
    matched = CLCursor[]
    for cursor in cursors
        ismatch(cursor) && push!(matched, cursor)
    end
    return matched
end
search(c::CLCursor, ismatch::Function) = search(children(c), ismatch)
search(c::CLCursor, s::String) = search(c, x -> spelling(x) == s)
search(c::CLCursor, k::CXCursorKind) = search(c, x -> kind(x) == k)

# visitor
function cu_children_visitor(cursor::CXCursor, parent::CXCursor, list)::Cuint
    push!(list, cursor)
    return CXChildVisit_Continue
end

"""
    children(cursor::CXCursor) -> Vector{CXCursor}
    children(cursor::CLCursor) -> Vector{CLCursor}
Return immediate cursors of the given cursor.
"""
function children(cursor::CXCursor)
    # TODO: possible to use sizehint! here?
    list = CXCursor[]
    cu_visitor_cb = @cfunction(
        cu_children_visitor, Cuint, (CXCursor, CXCursor, Ref{Vector{CXCursor}})
    )
    GC.@preserve list ccall(
        (:clang_visitChildren, LibClang.libclang),
        UInt32,
        (CXCursor, CXCursorVisitor, Any),
        cursor,
        cu_visitor_cb,
        list,
    )
    return list
end
children(c::CLCursor)::Vector{CLCursor} = children(c.cursor)

"""
    function_args(cursor::CLCursor) -> Vector{CLCursor}
Return function arguments for a given cursor.
"""
function_args(cursor::CLCursor) = search(cursor, CXCursor_ParmDecl)

"""
    is_typedef_anon(current::CLCursor, next::CLCursor) -> Bool
Return true if the current cursor is an typedef anonymous struct/enum.
"""
function is_typedef_anon(current::CLCursor, next::CLCursor)
    !isempty(name(current)) && return false
    refback = children(next)
    if kind(next) == CXCursor_TypedefDecl && !isempty(refback) && isempty(name(refback[1]))
        return true
    else
        return false
    end
end
