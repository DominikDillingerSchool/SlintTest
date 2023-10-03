message(STATUS "Searching for Slint...")
find_package(Slint REQUIRED)

## Sources
set(HDRS
	)

set(UI
    "mainwindow.slint"
    )

set(SRCS
    "main.cpp"
	)

set(PROJECT_SOURCES ${SRCS} ${HDRS})

## Executable
message(STATUS "Building ${PROJECT_NAME}Executable...")

add_executable(${PROJECT_NAME}Executable)
target_sources(${PROJECT_NAME}Executable PRIVATE ${PROJECT_SOURCES})
slint_target_sources(${PROJECT_NAME}Executable ${UI})
target_link_libraries(${PROJECT_NAME}Executable PRIVATE Slint::Slint)
target_include_directories(${PROJECT_NAME}Executable PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

# Static link to runtime library
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  target_link_options(${PROJECT_NAME}Executable PRIVATE -stdlib=libc++ -lpthread -g)
elseif(MSVC)
  # target_link_options(${PROJECT_NAME}Executable PRIVATE "/MT")
else()
  target_link_options(${PROJECT_NAME}Executable PRIVATE -static-libstdc++ -static-libgcc -g)
endif()

# On Windows, copy the Slint DLL next to the application binary so that it's found.
if (WIN32)
    add_custom_command(TARGET ${PROJECT_NAME}Executable 
    POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:${PROJECT_NAME}Executable> $<TARGET_FILE_DIR:${PROJECT_NAME}Executable> COMMAND_EXPAND_LISTS)
endif()

## Install
install(TARGETS ${PROJECT_NAME}Executable DESTINATION executable)
install(FILES $<TARGET_RUNTIME_DLLS:${PROJECT_NAME}Executable> DESTINATION executable)

# Find the C++ compiler path
find_program(CMAKE_CXX_COMPILER NAMES c++ g++ cl)

# Check if the C++ compiler was found
if(CMAKE_CXX_COMPILER)
  # Get the directory where the C++ compiler is located
  get_filename_component(COMPILER_PATH "${CMAKE_CXX_COMPILER}" DIRECTORY)
  message(STATUS "Found C++ compiler: ${CMAKE_CXX_COMPILER}")
else()
  message(FATAL_ERROR "Could not find C++ compiler")
endif()
install(TARGETS ${PROJECT_NAME}Executable RUNTIME_DEPENDENCIES
  PRE_EXCLUDE_REGEXES "api-ms-" "ext-ms-"
  POST_EXCLUDE_REGEXES ".*system32/.*\\.dll"
  DIRECTORIES ${CMAKE_CXX_COMPILER}
  DESTINATION executable
)
