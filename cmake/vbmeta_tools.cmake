project(vbmeta_tools CXX)
set(source_dir ${CMAKE_SOURCE_DIR}/extras/vbmeta_tools)
add_executable(vbmake ${source_dir}/vbmake.cc)
target_include_directories(vbmake PRIVATE
  ${CMAKE_SOURCE_DIR}/core/fs_mgr/libvbmeta/include
)
target_compile_options(vbmake PRIVATE "--include=cstring")
target_link_libraries(vbmake vbmeta)
