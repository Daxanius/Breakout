cmake_minimum_required(VERSION 3.8)
project(LittleLuaEngine)

# The C++ standard version
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

# Directories
set(LUA_DIR ${CMAKE_SOURCE_DIR}/libraries/lua)
set(AUBIO_DIR ${CMAKE_SOURCE_DIR}/libraries/aubio)

# Collect Lua sources (excluding lua.c and luac.c)
file(GLOB LUA_C_SOURCES ${LUA_DIR}/*.c)
list(REMOVE_ITEM LUA_C_SOURCES 
    ${LUA_DIR}/lua.c
    ${LUA_DIR}/luac.c
)

file(GLOB LUA_HEADERS ${LUA_DIR}/*.h)

# Collect project sources
set(SOURCES 
    "src/GameEngine.cpp"
    "src/GameEngine.h"
    "src/GameWinMain.cpp"
    "src/GameWinMain.h"
    "src/AbstractGame.cpp"
    "src/AbstractGame.h"
    "src/resource.h"
    "src/Game.cpp"
    "src/Game.h"
    "src/GameDefines.h"
    "src/Vector.h"
    "src/Vector.cpp"
    "src/Rectangle.h" 
    "src/Rectangle.cpp" 
    "src/RaycastCommon.h" 
    "src/RaycastCommon.cpp"
)

# Add executable for the project
add_executable(${PROJECT_NAME} WIN32 ${SOURCES})

set_target_properties(${PROJECT_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY $<TARGET_FILE_DIR:${PROJECT_NAME}>)

# Add Lua as a separate static library
add_library(Lua STATIC ${LUA_C_SOURCES} "src/RaycastCommon.h")
set_target_properties(Lua PROPERTIES LANGUAGE C)  # Ensure Lua is compiled as C
target_include_directories(Lua PUBLIC ${LUA_DIR})

# Include stuff
include(FetchContent)

# Fetch sol2
FetchContent_Declare(
    sol2 
    GIT_REPOSITORY https://github.com/ThePhD/sol2.git
    GIT_TAG v3.3.1
)

# FetchContent makes the content available
FetchContent_MakeAvailable(sol2)

# Link libraries
target_link_libraries(${PROJECT_NAME} PRIVATE ${AUBIO_DIR}/lib/aubio.dll.a)
target_link_libraries(${PROJECT_NAME} PRIVATE sol2 Lua)
target_link_directories(${PROJECT_NAME} PRIVATE ${AUBIO_DIR}/lib)
target_link_libraries(${PROJECT_NAME} PRIVATE aubio)

target_include_directories(${PROJECT_NAME} PRIVATE ${sol2_SOURCE_DIR}/include)
target_include_directories(${PROJECT_NAME} PRIVATE ${AUBIO_DIR}/include)

# Group source files in Visual Studio	
source_group(TREE ${PROJECT_SOURCE_DIR}/src PREFIX "src" FILES ${SOURCES})
source_group(src FILES ${LUA_C_SOURCES} ${LUA_HEADERS})

add_compile_definitions(UNICODE)
add_compile_definitions(_UNICODE)

target_compile_definitions(${PROJECT_NAME} PRIVATE ASSET_PATH="${CMAKE_CURRENT_LIST_DIR}/game")

# Define the source and output directories
set(RESOURCES_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/game")
set(RESOURCES_OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/game/")

# Ensure the output directory exists
file(MAKE_DIRECTORY ${RESOURCES_OUT_DIR})

# Ensure the aubio DLL is available at runtime by copying it to the output directory
add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy
            ${AUBIO_DIR}/bin/libaubio-5.dll
            $<TARGET_FILE_DIR:${PROJECT_NAME}>
)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${RESOURCES_SOURCE_DIR}
    ${RESOURCES_OUT_DIR}
)