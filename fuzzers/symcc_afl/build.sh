#!/bin/bash
set -e

##
# Pre-requirements:
# - env FUZZER: path to fuzzer work dir
##

if [ ! -d "$FUZZER/afl" ] || [ ! -d "$FUZZER/symcc" ]; then
    echo "fetch.sh must be executed first."
    exit 1
fi

# build AFL
(
    cd "$FUZZER/afl"
    CC=clang make -j $(nproc)
    CC=clang make -j $(nproc) -C llvm_mode
)

# build Z3
(
    cd "$FUZZER/z3"
    mkdir build install cmake_conf
    cd build
    CXX=clang++ CC=clang cmake ../ \
        -DCMAKE_INSTALL_PREFIX="$FUZZER/z3/install" \
        -DCMAKE_INSTALL_Z3_CMAKE_PACKAGE_DIR="$FUZZER/z3/cmake_conf"
    make -j $(nproc)
    make install
)

# build SymCC
(
    cd "$FUZZER/symcc"
    mkdir build
    cd build
    cmake -G Ninja ../ \
        -DQSYM_BACKEND=ON \
        -DZ3_DIR="$FUZZER/z3/cmake_conf"
    ninja check
)

# build libc++
(
    cd "$FUZZER/llvm"
    mkdir libcxx_symcc libcxx_symcc_install
    cd libcxx_symcc
    export SYMCC_REGULAR_LIBCXX=yes
    export SYMCC_NO_SYMBOLIC_INPUT=yes
    cmake -G Ninja ../llvm \
        -DLLVM_ENABLE_PROJECTS="libcxx;libcxxabi" \
        -DLLVM_TARGETS_TO_BUILD="X86" \
        -DLLVM_DISTRIBUTION_COMPONENTS="cxx;cxxabi;cxx-headers" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="$FUZZER/llvm/libcxx_symcc_install" \
        -DCMAKE_C_COMPILER="$FUZZER/symcc/build/symcc" \
        -DCMAKE_CXX_COMPILER="$FUZZER/symcc/build/sym++"
    ninja distribution
    ninja install-distribution
)

# prepare output dirs
mkdir "$OUT/"{afl,symcc}

# compile afl_driver.cpp
"$FUZZER/afl/afl-clang-fast++" $CXXFLAGS -std=c++11 -c -fPIC \
    "$FUZZER/afl/afl_driver.cpp" -o "$OUT/afl/afl_driver.o"

export SYMCC_LIBCXX_PATH="$FUZZER/llvm/libcxx_symcc_install"
"$FUZZER/symcc/build/sym++" $CXXFLAGS -std=c++11 -c -fPIC \
    "$FUZZER/afl/afl_driver.cpp" -o "$OUT/symcc/afl_driver.o"
