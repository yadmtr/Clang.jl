using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    # LibraryProduct(prefix, ["libLLVM"], :libLLVM),
    # LibraryProduct(prefix, ["libLTO"], :libLTO),
    LibraryProduct(prefix, ["libclang"], :libclang),
    # FileProduct(prefix, "tools/llvm-config", :llvm_config),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/staticfloat/LLVMBuilder/releases/download/v6.0.1-3+nowasm"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc) => ("$bin_prefix/LLVM.v6.0.1.aarch64-linux-gnu.tar.gz", "a61c32ba4426fa373397c39a7a09291d65fbfa4f73eeb01e64ada71b2d442ce4"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf) => ("$bin_prefix/LLVM.v6.0.1.arm-linux-gnueabihf.tar.gz", "e5fb6e74f156686087dd378c923c1002170355f30d4ebb37026d68b6b7884191"),
    Linux(:i686, libc=:glibc) => ("$bin_prefix/LLVM.v6.0.1.i686-linux-gnu.tar.gz", "53c52f852a5eaab4a1e225d071387931cf9cc56ebaea7c4fc4afe62450dd8f38"),
    Windows(:i686) => ("$bin_prefix/LLVM.v6.0.1.i686-w64-mingw32.tar.gz", "5da812e8f7c816d35c872004fe9c87e1430b3bc4616be3e3c5b82f6ed85db266"),
    Linux(:powerpc64le, libc=:glibc) => ("$bin_prefix/LLVM.v6.0.1.powerpc64le-linux-gnu.tar.gz", "521b946a5d2d47e6c88a6a46fe2457f88ebad55f55f28f0a786339129561c48d"),
    MacOS(:x86_64) => ("$bin_prefix/LLVM.v6.0.1.x86_64-apple-darwin14.tar.gz", "8a9fffa9c11ad01998e9cd6c7c4837bbb4d632e2a7bfcc6da67a90f3c0976368"),
    Linux(:x86_64, libc=:glibc) => ("$bin_prefix/LLVM.v6.0.1.x86_64-linux-gnu.tar.gz", "9b766a5d6f04054776b57bd5c0a13047c0fd02960cb5857fdf5afa1a8a4682ca"),
    Windows(:x86_64) => ("$bin_prefix/LLVM.v6.0.1.x86_64-w64-mingw32.tar.gz", "5a78d27ba586d2a4b75712a10035f6e9361a47442a774df001b8d975d4d844ff"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
