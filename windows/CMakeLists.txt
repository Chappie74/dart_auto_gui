cmake_minimum_required(VERSION 3.14)
set(CMAKE_CXX_STANDARD 17)

# Project-level configuration.
set(PROJECT_NAME "dart_auto_gui_windows")
project(${PROJECT_NAME} LANGUAGES CXX)

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "dart_auto_gui_windows")

list(APPEND PLUGIN_SOURCES
    "src/dart_auto_gui_windows.cpp"
    "src/utils.cpp"
    "src/mouse.cpp"
    "src/keyboard_keys.cpp"
    "src/keyboard.cpp"
)

add_library(${PLUGIN_NAME} SHARED
    ${PLUGIN_SOURCES}
)

set_target_properties(${PLUGIN_NAME} PROPERTIES
    CXX_VISIBILITY_PRESET hidden)

target_include_directories(${PLUGIN_NAME} PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/include/dart_auto_gui_windows"
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
)

set_target_properties(${PLUGIN_NAME} PROPERTIES
    OUTPUT_NAME ${PLUGIN_NAME}
)
