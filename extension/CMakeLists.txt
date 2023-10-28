cmake_minimum_required(VERSION 3.27)
project(libacc)

# include(ExternalProject)
# externalproject_add(ext_libacc
#     PREFIX          ext_libacc
#     GIT_REPOSITORY  https://github.com/nmoehrle/libacc.git
#     UPDATE_COMMAND  ""
#     SOURCE_DIR      ${CMAKE_SOURCE_DIR}/include/libacc
#     CONFIGURE_COMMAND ""
#     BUILD_COMMAND   ""
#     INSTALL_COMMAND ""
# )

find_package(JlCxx REQUIRED)
get_target_property(JlCxx_location JlCxx::cxxwrap_julia LOCATION)
get_filename_component(JlCxx_location ${JlCxx_location} DIRECTORY)

set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib;${JlCxx_location}")

add_library(accwrap SHARED libacc.cpp vector.h algo.h)
target_include_directories(accwrap PRIVATE ${CMAKE_SOURCE_DIR}/include/libacc)
target_link_libraries(accwrap JlCxx::cxxwrap_julia)
target_link_libraries(accwrap ${JLCXX_TARGET} ${JLCXX_STL_TARGET} ${Julia_LIBRARY})
# target_link_libraries(accwrap acc)

# install(TARGETS
#   accwrap
# ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
# LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
# RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
# INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/jlcxx-examples)
