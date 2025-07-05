SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_SYSTEM_PROCESSOR aarch64)

# Use specific GCC versions to match the working amd64 setup
SET(CMAKE_C_COMPILER "gcc-13")
SET(CMAKE_CXX_COMPILER "g++-13")

# Not cross-compiling, we're native ARM64
SET(CMAKE_CROSSCOMPILING FALSE)

# Use gold linker for better performance (like amd64 version)
SET(CMAKE_EXE_LINKER_FLAGS_INIT "-fuse-ld=gold")
SET(CMAKE_MODULE_LINKER_FLAGS_INIT "-fuse-ld=gold")
SET(CMAKE_SHARED_LINKER_FLAGS_INIT "-fuse-ld=gold")

# Disable precompiled headers to improve ccache hit ratio
SET(CMAKE_DISABLE_PRECOMPILE_HEADERS ON)

# ARM64 specific compiler flags - use conservative settings for compatibility
SET(CMAKE_C_FLAGS_INIT "-march=armv8-a -mtune=generic")
SET(CMAKE_CXX_FLAGS_INIT "-march=armv8-a -mtune=generic") 