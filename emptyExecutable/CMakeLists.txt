if(NOT QT_DEFAULT_MAJOR_VERSION)
    set(QT_DEFAULT_MAJOR_VERSION 5 CACHE STRING "Qt version to use (5 or 6), defaults to 5")
endif()

find_package(Qt${QT_DEFAULT_MAJOR_VERSION} REQUIRED COMPONENTS Core Gui Widgets)

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
message(STATUS "Building ${PROJECT_NAME}EmptyExecutable...")

add_executable(${PROJECT_NAME}EmptyExecutable)
target_sources(${PROJECT_NAME}EmptyExecutable PRIVATE ${PROJECT_SOURCES})
slint_target_sources(${PROJECT_NAME}EmptyExecutable ${UI})
target_link_libraries(${PROJECT_NAME}EmptyExecutable PRIVATE Slint::Slint)
target_include_directories(${PROJECT_NAME}EmptyExecutable PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

# Static link to runtime library
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  target_link_options(${PROJECT_NAME}EmptyExecutable PRIVATE -stdlib=libc++ -lpthread -g)
elseif(MSVC)
  target_compile_options(${PROJECT_NAME}EmptyExecutable PRIVATE "/MT")
else()
  target_link_options(${PROJECT_NAME}EmptyExecutable PRIVATE -static-libstdc++ -static-libgcc -g)
endif()

# On Windows, copy the Slint DLL next to the application binary so that it's found.
if (WIN32)
    add_custom_command(TARGET ${PROJECT_NAME}EmptyExecutable 
    POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:${PROJECT_NAME}EmptyExecutable> $<TARGET_FILE_DIR:${PROJECT_NAME}EmptyExecutable> COMMAND_EXPAND_LISTS)
endif()

## Install
install(TARGETS ${PROJECT_NAME}EmptyExecutable DESTINATION executable)
install(FILES $<TARGET_RUNTIME_DLLS:${PROJECT_NAME}EmptyExecutable> DESTINATION executable)
