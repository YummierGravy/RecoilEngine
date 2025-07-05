# ARM64 Linux docker environment - based on working amd64-linux/Dockerfile.20.04
FROM ubuntu:20.04
ENV ENGINE_PLATFORM=arm64-linux
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install --no-install-recommends --yes software-properties-common \
 && add-apt-repository ppa:ubuntu-toolchain-r/test --yes \
 && apt-get update \
 && apt-get install --no-install-recommends --yes \
    curl gcc-13 g++-13 git ninja-build p7zip-full python3-pip python3-setuptools \
    libsdl2-dev libopenal-dev libfreetype6-dev libfontconfig1-dev xz-utils make uuid-dev \
 && apt-get remove --purge --yes software-properties-common \
 && apt-get autoremove --purge --yes \
 && apt-get upgrade --yes \
 && rm -rf /var/lib/apt/lists/*

# And need newer zstd :(, fortunately it's quick build
RUN git clone --depth 1 --branch v1.5.6 https://github.com/facebook/zstd.git \
 && cd zstd \
 && CC=g++-13 make -j$(nproc) \
 && mv programs/zstd /usr/local/bin \
 && cd .. \
 && rm -rf zstd

RUN pip3 install --upgrade pip \
 && pip3 install scikit-build \
 && pip3 install cmake==3.27.*

# Use system ccache for now (simpler and the threading issue is already fixed)
RUN apt-get update && apt-get install -y ccache \
 && rm -rf /var/lib/apt/lists/* \
 && ccache --version

WORKDIR /build
RUN mkdir src cache out artifacts && chmod a+rwx cache out artifacts

# Fix git ownership issues in Docker
RUN git config --global --add safe.directory /build/src \
 && git config --global --add safe.directory /build/src/tools/pr-downloader

# Fetch library dependencies and configure resolution (try ARM64 branch or fallback)
RUN git clone --depth=1 https://github.com/beyond-all-reason/spring-static-libs.git -b arm64 spring-static-libs || \
    git clone --depth=1 https://github.com/beyond-all-reason/spring-static-libs.git -b 20.04 spring-static-libs || \
    git clone --depth=1 https://github.com/beyond-all-reason/spring-static-libs.git spring-static-libs
ENV PKG_CONFIG_LIBDIR=/build/spring-static-libs/lib/pkgconfig
ENV PKG_CONFIG="pkg-config --define-prefix --static"
ENV CMAKE_PREFIX_PATH=/build/spring-static-libs/
ENV PREFER_STATIC_LIBS=TRUE

# Fontconfig cmake doesn't seem to be properly setup (adapted for ARM64)
RUN sed -i 's/ IMPORTED_LOCATION "\${Fontconfig_LIBRARY}"/&\n   INTERFACE_LINK_LIBRARIES "\/usr\/lib\/aarch64-linux-gnu\/libuuid\.a"/' /usr/local/lib/python3.8/dist-packages/cmake/data/share/cmake-3.27/Modules/FindFontconfig.cmake

# Set up default cmake toolchain
COPY toolchain.cmake .
ENV CMAKE_TOOLCHAIN_FILE=/build/toolchain.cmake

# Configure ccache caching
COPY ccache.conf .
ENV CCACHE_CONFIGPATH=/build/ccache.conf
ENV CMAKE_CXX_COMPILER_LAUNCHER=ccache
ENV CMAKE_C_COMPILER_LAUNCHER=ccache 