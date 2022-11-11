project(libsparse CXX)
set(source_dir ${CMAKE_SOURCE_DIR}/core/libsparse)
set(sources
  ${source_dir}/backed_block.cpp
  ${source_dir}/output_file.cpp
  ${source_dir}/sparse.cpp
  ${source_dir}/sparse_crc32.cpp
  ${source_dir}/sparse_err.cpp
  ${source_dir}/sparse_read.cpp
)
add_library(sparse EXCLUDE_FROM_ALL ${sources})
target_include_directories(sparse PRIVATE
  ${source_dir}/include
  ${CMAKE_SOURCE_DIR}/libbase/include
)

add_executable(img2simg ${source_dir}/img2simg.cpp)
target_include_directories(img2simg PRIVATE ${source_dir}/include)
target_link_libraries(img2simg sparse zlibstatic base)
target_link_options(img2simg PRIVATE -static -s -Wl,--allow-multiple-definition)

add_executable(simg2img ${source_dir}/simg2img.cpp)
target_include_directories(simg2img PRIVATE ${source_dir}/include)
target_link_libraries(simg2img sparse zlibstatic base)
target_link_options(simg2img PRIVATE -static -s -Wl,--allow-multiple-definition)

add_executable(simg2simg EXCLUDE_FROM_ALL ${source_dir}/simg2simg.cpp) # TODO: Remove EXCLUDE_FROM_ALL when compilable
target_compile_options(simg2simg PRIVATE -Wno-incompatible-pointer-types)
target_include_directories(simg2simg PRIVATE ${source_dir}/include)
target_link_libraries(simg2simg sparse zlibstatic base)
target_link_options(simg2simg PRIVATE -static -s -Wl,--allow-multiple-definition)

add_executable(append2simg ${source_dir}/append2simg.cpp)
target_include_directories(append2simg PRIVATE ${source_dir}/include)
target_link_libraries(append2simg sparse zlibstatic base)
target_link_options(append2simg PRIVATE -static -s -Wl,--allow-multiple-definition)

#add_dependencies(img2simg simg2img simg2simg append2simg)
