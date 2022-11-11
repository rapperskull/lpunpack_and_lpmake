project(libjsonpb CXX)
set(source_dir ${CMAKE_SOURCE_DIR}/extras/libjsonpb)
add_library(jsonpbparse EXCLUDE_FROM_ALL ${source_dir}/parse/jsonpb.cpp)
target_include_directories(jsonpbparse PRIVATE
  ${source_dir}/parse/include
  ${CMAKE_SOURCE_DIR}/libbase/include
  ${CMAKE_SOURCE_DIR}/lib/protobuf/src
)
# Full path to libprotobuf.a because otherwise it tries to dynamically link libz.so
target_link_libraries(jsonpbparse base ${LIBRARY_OUTPUT_PATH}/libprotobuf.a)
