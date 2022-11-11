project(liblp CXX)
set(source_dir ${CMAKE_SOURCE_DIR}/core/fs_mgr/liblp)
set(sources
  ${source_dir}/builder.cpp
  ${source_dir}/images.cpp
  ${source_dir}/partition_opener.cpp
  ${source_dir}/property_fetcher.cpp
  ${source_dir}/reader.cpp
  ${source_dir}/utility.cpp
  ${source_dir}/writer.cpp
)
add_library(lp EXCLUDE_FROM_ALL ${sources})
target_include_directories(lp PRIVATE
  ${source_dir}/include
  ${CMAKE_SOURCE_DIR}/libbase/include
  ${CMAKE_SOURCE_DIR}/core/libsparse/include
  ${CMAKE_SOURCE_DIR}/extras/ext4_utils/include
  ${CMAKE_SOURCE_DIR}/lib/boringssl/include
)
target_compile_definitions(lp PRIVATE _FILE_OFFSET_BITS=64)
