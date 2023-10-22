cmake_minimum_required(VERSION 3.27)
project(libacc)

include_directories(${CMAKE_SOURCE_DIR}/include)
message(TARGET=${CMAKE_SOURCE_DIR})

find_package(JlCxx REQUIRED)
message(julia found: ${JULIA_FOUND})
get_target_property(JlCxx_location JlCxx::cxxwrap_julia LOCATION)
get_filename_component(JlCxx_location ${JlCxx_location} DIRECTORY)
message(STATUS "Found JlCxx at ${JlCxx_location}")

set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib;${JlCxx_location}")
message(STATUS "Found JlCxx at ${CMAKE_INSTALL_RPATH}")

add_library(acc SHARED libacc.cpp)
target_link_libraries(acc JlCxx::cxxwrap_julia)
target_link_libraries(acc ${JLCXX_TARGET} ${JLCXX_STL_TARGET} ${Julia_LIBRARY})

install(TARGETS
  acc
ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/jlcxx-examples)
