project(partition_tools CXX)
set(source_dir ${CMAKE_SOURCE_DIR}/extras/partition_tools)
set(target_list lpmake lpadd lpflash lpunpack lpdump)
set(libdeps base log lp)

add_custom_command(WORKING_DIRECTORY ${source_dir}
  OUTPUT ${source_dir}/dynamic_partitions_device_info.pb.cc ${source_dir}/dynamic_partitions_device_info.pb.h
  COMMAND protoc --cpp_out=. dynamic_partitions_device_info.proto
  DEPENDS ${source_dir}/dynamic_partitions_device_info.proto
)

set(common_includes
  ${CMAKE_SOURCE_DIR}/libbase/include
  ${CMAKE_SOURCE_DIR}/core/fs_mgr/liblp/include
)
set(lpmake_includes
  ${CMAKE_SOURCE_DIR}/lib/fmt/include
)
set(lpadd_includes
  ${CMAKE_SOURCE_DIR}/core/libsparse/include
)
set(lpunpack_includes ${lpadd_includes})

set(lpdump_includes
  ${CMAKE_SOURCE_DIR}/extras/libjsonpb/parse/include
  ${CMAKE_SOURCE_DIR}/lib/protobuf/src
)

add_library(lpdump-lib EXCLUDE_FROM_ALL
  ${source_dir}/lpdump.cc
  ${source_dir}/dynamic_partitions_device_info.pb.cc
)
target_include_directories(lpdump-lib PRIVATE ${common_includes} ${lpdump_includes})
target_compile_definitions(lpdump-lib PRIVATE _FILE_OFFSET_BITS=64)
target_link_libraries(lpdump-lib jsonpbparse)
set_target_properties(lpdump-lib PROPERTIES OUTPUT_NAME lpdump)

foreach(target ${target_list})
  add_executable(${target} ${source_dir}/${target}.cc)
  if(${target} STREQUAL lpdump)
    target_sources(${target} PRIVATE ${source_dir}/${target}_host.cc)
  endif()
  target_include_directories(${target} PRIVATE ${common_includes} ${${target}_includes})
  target_link_options(${target} PRIVATE -static -s)
  target_compile_definitions(${target} PRIVATE _FILE_OFFSET_BITS=64)
  target_link_libraries(${target} ${libdeps})
  if(${target} STREQUAL lpadd OR ${target} STREQUAL lpunpack)
    target_link_libraries(${target} sparse)
  elseif(${target} STREQUAL lpdump)
    target_link_libraries(${target} lpdump-lib)
  endif()
endforeach()

add_custom_target(partition_tools DEPENDS ${target_list})
