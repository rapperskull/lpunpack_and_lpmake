project(libext4_utils CXX)
set(source_dir ${CMAKE_SOURCE_DIR}/extras/ext4_utils)
set(sources
  ${source_dir}/ext4_utils.cpp
  ${source_dir}/wipe.cpp
  ${source_dir}/ext4_sb.cpp
)
add_library(ext4_utils EXCLUDE_FROM_ALL ${sources})
target_include_directories(ext4_utils PRIVATE
  ${source_dir}/include
  ${CMAKE_SOURCE_DIR}/libbase/include
)
target_compile_options(ext4_utils PRIVATE -fno-strict-aliasing)
