project(libjsonpb CXX)
set(source_dir ${CMAKE_SOURCE_DIR}/extras/libjsonpb)
set(sources ${source_dir}/parse/jsonpb.cpp)
add_library(jsonpbparse EXCLUDE_FROM_ALL ${sources})
target_include_directories(jsonpbparse PRIVATE
  ${source_dir}/parse/include
  ${CMAKE_SOURCE_DIR}/libbase/include
  ${CMAKE_SOURCE_DIR}/lib/protobuf/src
)
