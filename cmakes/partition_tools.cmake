project(partition_tools CXX)
set(source_dir ${CMAKE_SOURCE_DIR}/extras/partition_tools)
set(target_list lpmake lpadd lpflash lpunpack)
set(libdeps lp sparse ext4_utils zlibstatic base fmt log crypto_utils crypto)

add_custom_command(WORKING_DIRECTORY ${source_dir}
  OUTPUT ${source_dir}/dynamic_partitions_device_info.pb.cc ${source_dir}/dynamic_partitions_device_info.pb.h
  COMMAND protoc --cpp_out=. dynamic_partitions_device_info.proto
  DEPENDS ${source_dir}/dynamic_partitions_device_info.proto
)

foreach(target ${target_list})
  add_executable(${target} ${source_dir}/${target}.cc)
  target_include_directories(${target} PRIVATE
    ${CMAKE_SOURCE_DIR}/libbase/include
    ${CMAKE_SOURCE_DIR}/core/fs_mgr/liblp/include
    ${CMAKE_SOURCE_DIR}/core/libsparse/include
    #${CMAKE_SOURCE_DIR}/partition_tools/mgr/liblp/include
  )
  target_link_options(${target} PRIVATE -static -s -Wl,--allow-multiple-definition)
  target_compile_definitions(${target} PRIVATE _FILE_OFFSET_BITS=64)
  target_link_libraries(${target} ${libdeps})
endforeach()

add_executable(lpdump
  ${source_dir}/lpdump.cc
  ${source_dir}/dynamic_partitions_device_info.pb.cc
  ${source_dir}/lpdump_host.cc
)
target_include_directories(lpdump PRIVATE
  ${CMAKE_SOURCE_DIR}/libbase/include
  ${CMAKE_SOURCE_DIR}/core/fs_mgr/liblp/include
  ${CMAKE_SOURCE_DIR}/core/libsparse/include
  ${CMAKE_SOURCE_DIR}/extras/libjsonpb/parse/include
  ${CMAKE_SOURCE_DIR}/lib/protobuf/src
)
target_link_options(lpdump PRIVATE -static -s -Wl,--allow-multiple-definition)
target_compile_definitions(lpdump PRIVATE _FILE_OFFSET_BITS=64)
target_link_libraries(lpdump ${libdeps} jsonpbparse ${LIBRARY_OUTPUT_PATH}/libprotobuf.a) # Full path to libprotobuf.a because otherwise it tries to dynamically link libz.so

#add_dependencies(lpmake lpadd lpflash lpunpack lpdump)
