#!/bin/bash

BUILD_TYPE=Release

RAFT_REPO_REL="/share/workspace/rapids_projects/raft"
RAFT_REPO_PATH="`readlink -f \"${RAFT_REPO_REL}\"`"

set -e

if [ "$1" == "clean" ]; then
  rm -rf build
  exit 0
fi

if [ "$1" == "test" ]; then
  make -C build -j test
  exit 0
fi

if [ "$1" == "test-raft" ]; then
  ./build/faiss/gpu/test/TestRaftIndexIVFFlat
  exit 0
fi

mkdir -p build/ && cd build/
cmake \
 -DFAISS_ENABLE_GPU=ON \
 -DFAISS_ENABLE_PYTHON=OFF \
 -DBUILD_TESTING=ON \
 -DBUILD_SHARED_LIBS=OFF \
 -DCPM_raft_SOURCE=${RAFT_REPO_REL} \
 -DFAISS_ENABLE_RAFT=ON \
 -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
 -DFAISS_OPT_LEVEL=avx2 \
 -DRAFT_NVTX=OFF \
 -DCMAKE_CUDA_ARCHITECTURES="NATIVE" \
 -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
 -DCMAKE_CUDA_COMPILER_LAUNCHER=ccache \
 -DCMAKE_C_COMPILER_LAUNCHER=ccache \
 -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
 ../

cmake  --build . -j12
