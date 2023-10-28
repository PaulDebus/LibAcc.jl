cmake_minimum_required(VERSION 3.27)
project(libacc)

include(ExternalProject)
externalproject_add(ext_libacc
    PREFIX          ext_libacc
    GIT_REPOSITORY  https://github.com/nmoehrle/libacc.git
    UPDATE_COMMAND  ""
    SOURCE_DIR      ${CMAKE_SOURCE_DIR}/include/libacc
    CONFIGURE_COMMAND ""
    BUILD_COMMAND   ""
    INSTALL_COMMAND ""
)

find_package(JlCxx REQUIRED)
get_target_property(JlCxx_location JlCxx::cxxwrap_julia LOCATION)
get_filename_component(JlCxx_location ${JlCxx_location} DIRECTORY)

set(MATH_FILES "${CMAKE_SOURCE_DIR}/include/math/vector.h" "${CMAKE_SOURCE_DIR}/include/math/algo.h")
add_library(accwrap SHARED libacc.cpp ${MATH_FILES})
target_include_directories(accwrap PRIVATE ${CMAKE_SOURCE_DIR}/include/libacc)
target_include_directories(accwrap PRIVATE ${CMAKE_SOURCE_DIR}/include/math)
target_link_libraries(accwrap JlCxx::cxxwrap_julia)
target_link_libraries(accwrap ${JLCXX_TARGET} ${JLCXX_STL_TARGET} ${Julia_LIBRARY})

# install(TARGETS
#   accwrap
#   LIBRARY DESTINATION ../)
