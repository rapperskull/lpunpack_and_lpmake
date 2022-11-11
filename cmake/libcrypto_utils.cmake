project(libcrypto_utils CXX)
set(source_dir ${CMAKE_SOURCE_DIR}/core/libcrypto_utils)
set(sources ${source_dir}/android_pubkey.cpp)
add_library(crypto_utils EXCLUDE_FROM_ALL ${sources})
target_include_directories(crypto_utils PRIVATE
  ${source_dir}/include
  ${CMAKE_SOURCE_DIR}/lib/boringssl/include
)
target_link_libraries(crypto_utils crypto)
