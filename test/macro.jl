using Clang
using Clang.LibClang
using Test

@testset "macro" begin
    trans_unit = parse_header(joinpath(@__DIR__, "c", "macro.h"),
                              flags = CXTranslationUnit_DetailedPreprocessingRecord |
                                      CXTranslationUnit_SkipFunctionBodies)
    root_cursor = getcursor(trans_unit)
    cursors = children(root_cursor)
    g_uri_xxx = search(cursors, x->name(x)=="G_URI_RESERVED_CHARS_SUBCOMPONENT_DELIMITERS")[1]
    ctx = DefaultContext()
    push!(ctx.trans_units, trans_unit)
    wrap!(ctx, g_uri_xxx)
    expr = :(const G_URI_RESERVED_CHARS_SUBCOMPONENT_DELIMITERS = "!\$&'()*+,;=")
    @test ctx.common_buffer[:G_URI_RESERVED_CHARS_SUBCOMPONENT_DELIMITERS].items[1] == expr
end