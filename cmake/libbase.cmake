project(libbase CXX)
set(source_dir ${CMAKE_SOURCE_DIR}/libbase)
set(sources
  ${source_dir}/abi_compatibility.cpp
  ${source_dir}/chrono_utils.cpp
  ${source_dir}/cmsg.cpp
  ${source_dir}/file.cpp
  ${source_dir}/logging.cpp
  ${source_dir}/mapped_file.cpp
  ${source_dir}/parsebool.cpp
  ${source_dir}/parsenetaddress.cpp
  ${source_dir}/posix_strerror_r.cpp
  ${source_dir}/process.cpp
  ${source_dir}/properties.cpp
  ${source_dir}/stringprintf.cpp
  ${source_dir}/strings.cpp
  ${source_dir}/threads.cpp
  ${source_dir}/test_utils.cpp
)
if(UNIX)
  list(APPEND sources ${source_dir}/errors_unix.cpp)
elseif(WIN32)
  list(APPEND sources ${source_dir}/errors_windows.cpp ${source_dir}/utf8.cpp)
  list(REMOVE_ITEM sources ${source_dir}/cmsg.cpp)
endif()
add_library(base EXCLUDE_FROM_ALL ${sources})
target_include_directories(base PRIVATE
  ${source_dir}/include
  ${CMAKE_SOURCE_DIR}/logging/liblog/include
  ${CMAKE_SOURCE_DIR}/lib/fmt/include
)
target_link_libraries(base log)
