cmake_minimum_required(VERSION 3.22)
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
project(lpunpack_and_lpmake CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Xclang -flto-visibility-public-std")
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin/lib)

list(APPEND CMAKE_MODULE_PATH
  ${CMAKE_CURRENT_LIST_DIR}/cmake
  ${PROJECT_SOURCE_DIR}/lib/zlib
  ${PROJECT_SOURCE_DIR}/lib/fmt
  ${PROJECT_SOURCE_DIR}/lib/boringssl
  ${PROJECT_SOURCE_DIR}/lib/protobuf
)

file(MAKE_DIRECTORY ${EXECUTABLE_OUTPUT_PATH} ${LIBRARY_OUTPUT_PATH})

include(liblog)
add_subdirectory(lib/zlib EXCLUDE_FROM_ALL)
include(libbase)
include(libsparse)
add_subdirectory(lib/fmt EXCLUDE_FROM_ALL)
include(liblp)
include(ext4_utils)
include(libcrypto_utils)
add_subdirectory(lib/boringssl EXCLUDE_FROM_ALL)
set(protobuf_BUILD_SHARED_LIBS OFF)
add_subdirectory(lib/protobuf EXCLUDE_FROM_ALL)
add_dependencies(libprotobuf zlibstatic)
include(libjsonpb)
include(partition_tools)

include(libvbmeta)
include(vbmeta_tools)
