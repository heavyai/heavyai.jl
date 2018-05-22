cmake_minimum_required(VERSION 2.8)
project(MapDLib)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules")

find_package(Boost REQUIRED QUIET)
find_package(Thrift REQUIRED)
include_directories(${Boost_INCLUDE_DIR} ${Thrift_INCLUDE_DIRS})

add_custom_command(
    DEPENDS ${CMAKE_SOURCE_DIR}/mapd.thrift
    OUTPUT
        ${CMAKE_BINARY_DIR}/gen-cpp/MapD.cpp
        ${CMAKE_BINARY_DIR}/gen-cpp/MapD.h
        ${CMAKE_BINARY_DIR}/gen-cpp/mapd_constants.cpp
        ${CMAKE_BINARY_DIR}/gen-cpp/mapd_types.cpp
        ${CMAKE_BINARY_DIR}/gen-cpp/completion_hints_constants.cpp
        ${CMAKE_BINARY_DIR}/gen-cpp/completion_hints_types.cpp
    COMMAND ${Thrift_EXECUTABLE}
    ARGS -gen cpp -r -o ${CMAKE_BINARY_DIR} ${CMAKE_SOURCE_DIR}/mapd.thrift)
list(APPEND ADDITIONAL_MAKE_CLEAN_FILES ${CMAKE_BINARY_DIR}/gen-cpp/)

add_library(mapd_thrift
    SHARED
    ${CMAKE_BINARY_DIR}/gen-cpp/MapD.cpp
    ${CMAKE_BINARY_DIR}/gen-cpp/MapD.h
    ${CMAKE_BINARY_DIR}/gen-cpp/mapd_constants.cpp
    ${CMAKE_BINARY_DIR}/gen-cpp/mapd_types.cpp
    ${CMAKE_BINARY_DIR}/gen-cpp/completion_hints_constants.cpp
    ${CMAKE_BINARY_DIR}/gen-cpp/completion_hints_types.cpp)
target_compile_options(mapd_thrift PRIVATE -fPIC)
target_link_libraries(mapd_thrift ${Thrift_LIBRARIES})
set_target_properties(mapd_thrift PROPERTIES VERSION 1.0.0)
set_target_properties(mapd_thrift PROPERTIES SOVERSION 1)
