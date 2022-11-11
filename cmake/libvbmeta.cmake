project(libvbmeta CXX)
set(source_dir ${CMAKE_SOURCE_DIR}/core/fs_mgr/libvbmeta)
add_library(vbmeta EXCLUDE_FROM_ALL
  ${source_dir}/builder.cpp
  ${source_dir}/reader.cpp
  ${source_dir}/utility.cpp
  ${source_dir}/writer.cpp
)
target_include_directories(vbmeta PRIVATE
  ${source_dir}/include
  ${CMAKE_SOURCE_DIR}/logging/liblog/include
  ${CMAKE_SOURCE_DIR}/libbase/include
  ${CMAKE_SOURCE_DIR}/lib/boringssl/include
  ${CMAKE_SOURCE_DIR}/lib/fmt/include
)
target_link_libraries(vbmeta log base crypto)
