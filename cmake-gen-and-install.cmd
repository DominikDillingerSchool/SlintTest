@echo on
setlocal enabledelayedexpansion
rem call CMake generate and then compile and install debug and release version
rem
rem additionalBinariesDir - Points to additional binary directories needed by current project. ; seperated list of paths. Will be given to CMAKE_PREFIX_PATH.
rem     example: set additionalBinariesDir=U:\Daten\DEOB\Programme\ESO-Builds\All-Builds\Qt-GUI\trunk\latest\bin2017-5.15.1-x64
rem COMPILER_ID - select compiler to be used. Known: vs2017-x64, vs2017-x86, ....
rem     example: set COMPILER_ID=vs2017-x64
rem ENSURE_CLEAN_CMAKE - TRUE or FALSE, before generating delete cache file
rem     example: set ENSURE_CLEAN_CMAKE=TRUE
rem cmakeGenerateOptions - Additional options for CMake -G
rem CMAKE_COMMAND - What to do? Default: BUILD_AND_INSTALL
rem     example: set CMAKE_COMMAND=OPEN_IN_EDITOR

rem Please also see c:\devtools\bin\build_modern_cmake_example.cmd on how to used this file

rem Disable reuse of nodes, to avoid build failures
rem (c.f. : https://stackoverflow.com/questions/7916687/error-msb4166-child-node-exited-prematurely-shutting-down) (10.09.2020)
set MSBUILDDISABLENODEREUSE=1

rem if no COMPILER_ID provided then select vs2017-x64 as default
if "!COMPILER_ID!"=="" (set COMPILER_ID=vs2017-x64)

rem vs2019-x64
set CMAKE_COMPILER[vs2019-x64]="Visual Studio 16 2019" 
set CMAKE_ARCHITECTURE[vs2019-x64]=-A x64
rem enable parallel building at msbuild
set cmakeBuildOptions[vs2019-x64]=-- -m
set CXXFLAGS[vs2019-x64]=/W4

rem vs2019-x86
set CMAKE_COMPILER[vs2019-x86]="Visual Studio 16 2019"
set CMAKE_ARCHITECTURE[vs2019-x86]=-A Win32
rem enable parallel building at msbuild
set cmakeBuildOptions[vs2019-x86]=-- -m
set CXXFLAGS[vs2019-x86]=/W4

rem vs2017-x64
set CMAKE_COMPILER[vs2017-x64]="Visual Studio 15 2017" 
set CMAKE_ARCHITECTURE[vs2017-x64]=-A x64
rem enable parallel building at msbuild
set cmakeBuildOptions[vs2017-x64]=-- -m
set CXXFLAGS[vs2017-x64]=/W4

rem vs2017-x86
set CMAKE_COMPILER[vs2017-x86]="Visual Studio 15 2017"
set CMAKE_ARCHITECTURE[vs2017-x86]=-A Win32
rem enable parallel building at msbuild
set cmakeBuildOptions[vs2017-x86]=-- -m
set CXXFLAGS[vs2017-x86]=/W4

rem vs2022-x86
set PathAdditional[vs2022-x86]=C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/VC/Tools/MSVC/14.37.32822/bin/Hostx64/x64/;
set CMAKE_COMPILER[vs2022-x86]="Visual Studio 17 2022"
rem set CMAKE_ARCHITECTURE[vs2022-x86]=-A Win32
rem enable parallel building at msbuild
rem set cmakeBuildOptions[vs2022-x86]=-- -m
rem set CXXFLAGS[vs2022-x86]=/W4

rem mingw8-x64
set PathAdditional[mingw8-x64]=C:\DevTools\mingw\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\mingw64\bin;
set CC[mingw8-x64]=gcc.exe
set CXX[mingw8-x64]=g++.exe
set CMAKE_COMPILER[mingw8-x64]="Ninja Multi-Config"
set cmakeBuildOptions[mingw8-x64]=-- -v
set CXXFLAGS[mingw8-x64]=-Wall

rem mingw7-x64
set PathAdditional[mingw7-x64]=C:\DevTools\mingw\x86_64-7.3.0-release-posix-seh-rt_v5-rev0\mingw64\bin;
set CC[mingw7-x64]=gcc.exe
set CXX[mingw7-x64]=g++.exe
set CMAKE_COMPILER[mingw7-x64]="Ninja Multi-Config"
set cmakeBuildOptions[mingw7-x64]=-- -v
set CXXFLAGS[mingw7-x64]=-Wall

rem mingw7-x86
set PathAdditional[mingw7-x86]=C:\DevTools\mingw\i686-7.3.0-release-posix-dwarf-rt_v5-rev0\mingw32\bin;
set CC[mingw7-x86]=gcc.exe
set CXX[mingw7-x86]=g++.exe
set CMAKE_COMPILER[mingw7-x86]="Ninja Multi-Config"
set cmakeBuildOptions[mingw7-x86]=-- -v
set CXXFLAGS[mingw7-x86]=-Wall

rem vs2013-x64
set CMAKE_COMPILER[vs2013-x64]="Visual Studio 12 2013"
set CMAKE_ARCHITECTURE[vs2013-x64]=-A x64
rem enable parallel building at msbuild
set cmakeBuildOptions[vs2013-x64]=-- -m
set CXXFLAGS[vs2013-x64]=/W4

rem vs2013-x86
set CMAKE_COMPILER[vs2013-x86]="Visual Studio 12 2013"
set CMAKE_ARCHITECTURE[vs2013-x86]=-A Win32
rem enable parallel building at msbuild
set cmakeBuildOptions[vs2013-x86]=-- -m
set CXXFLAGS[vs2013-x86]=/W4

rem vs2008-x64
set CMAKE_COMPILER[vs2008-x64]="Visual Studio 9 2008"
set CMAKE_ARCHITECTURE[vs2008-x64]=-A x64

rem vs2008-x86
set CMAKE_COMPILER[vs2008-x86]="Visual Studio 9 2008"
set CMAKE_ARCHITECTURE[vs2008-x86]=-A Win32

rem LLVM-x64
set CMAKE_COMPILER[LLVM-x64]="Visual Studio 15 2017"
set CMAKE_ARCHITECTURE[LLVM-x64]=-T "LLVM_v141" -A "x64"

rem LLVM-x86
set CMAKE_COMPILER[LLVM-x86]="Visual Studio 15 2017"
set CMAKE_ARCHITECTURE[LLVM-x86]=-T "LLVM_v141" -A Win32

rem clang-x64
set PathAdditional[clang-x64]=C:\Program Files\LLVM\bin;
set CC[clang-x64]=clang.exe
set CXX[clang-x64]=clang++.exe
set CMAKE_COMPILER[clang-x64]="Ninja Multi-Config"
set cmakeBuildOptions[clang-x64]=-- -v

rem clang-x86
set PathAdditional[clang-x86]=C:\Program Files (x86)\LLVM\bin;
set CC[clang-x86]=clang.exe
set CXX[clang-x86]=clang++.exe
set CMAKE_COMPILER[clang-x86]="Ninja Multi-Config"
set cmakeBuildOptions[clang-x86]=-- -v

rem clang13-x64 in msys2
set PathAdditional[clang13-x64]=c:\msys64\clang64\bin;
set CC[clang13-x64]=clang.exe
set CXX[clang13-x64]=clang++.exe
set CMAKE_COMPILER[clang13-x64]="Ninja Multi-Config"
set cmakeBuildOptions[clang13-x64]=-- -v

set PathAdditional[clang13-x86]=c:\msys64\clang32\bin;
set CC[clang13-x86]=clang.exe
set CXX[clang13-x86]=clang++.exe
set CMAKE_COMPILER[clang13-x86]="Ninja Multi-Config"
set cmakeBuildOptions[clang13-x86]=-- -v
								
set PathAdditional[mingw64-x64]=c:\msys64\mingw64\bin;
set CC[mingw64-x64]=gcc.exe
set CXX[mingw64-x64]=g++.exe
set CMAKE_COMPILER[mingw64-x64]="Ninja Multi-Config"
set cmakeBuildOptions[mingw64-x64]=-- -v



rem For ninja users also provide start time information of command
set NINJA_STATUS="[%%f/%%t/%%e] "


rem Now set the actual used variables:
set CMAKE_COMPILER=!CMAKE_COMPILER[%COMPILER_ID%]!
set CMAKE_ARCHITECTURE=!CMAKE_ARCHITECTURE[%COMPILER_ID%]!

rem Allow cmake options set from outside aswell:
set cmakeGenerateOptions=-DCMAKE_MODULE_PATH=C:/DevTools/scripts/cmake %cmakeGenerateOptions% 
set cmakeBuildOptions=!cmakeBuildOptions[%COMPILER_ID%]! %cmakeBuildOptions%

set CC=!CC[%COMPILER_ID%]!
set CXX=!CXX[%COMPILER_ID%]!
set CXXFLAGS=!CXXFLAGS[%COMPILER_ID%]! 

set PATH=D:\msys2\mingw64\bin;!PathAdditional[%COMPILER_ID%]!%PATH%

if "%ENSURE_CLEAN_CMAKE%"=="" (
	set ENSURE_CLEAN_CMAKE=FALSE
)

set sources=%cd%

rem Respect given directories:
if "%workspace%" == "" (
	set workspace=%cd%
)
if "%SPECIAL_VARIANT_NAME%"=="" (
	set SPECIAL_VARIANT_NAME=%COMPILER_ID%
)
if "%buildDir%"=="" (
	set buildDir=%sources%\tmp-%SPECIAL_VARIANT_NAME%
)
if "%installDir%"=="" (
	set installDir=%workspace%\bin-%SPECIAL_VARIANT_NAME%
)

if "%CMAKE_COMMAND%"=="" (
	set CMAKE_COMMAND=BUILD_AND_INSTALL
)

mkdir %buildDir%
pushd %buildDir%

call :GENERATE
if errorlevel 1 goto ende

if "%CMAKE_COMMAND%"=="BUILD_AND_INSTALL" (
	call :BUILD_AND_INSTALL Release
	if errorlevel 1 goto ende
	call :BUILD_AND_INSTALL Debug
) else if "%CMAKE_COMMAND%"=="RUN_TESTS" (
	call :RUN_TESTS Release
	if errorlevel 1 goto ende
	call :RUN_TESTS Debug
) else if "%CMAKE_COMMAND%"=="OPEN_IN_EDITOR" (
	call :OPEN_IN_EDITOR
)
popd

goto ende

:GENERATE
rem 1 = (optional) cmake option

if "%ENSURE_CLEAN_CMAKE%"=="TRUE" (	del CMakeCache.txt )
cmake -G %CMAKE_COMPILER% %CMAKE_ARCHITECTURE% %sources% "-DCMAKE_PREFIX_PATH:PATH=%additionalBinariesDir%" -DCMAKE_INSTALL_PREFIX:PATH=%installDir% %~1 %cmakeGenerateOptions%
exit /b

:BUILD_AND_INSTALL
rem 1 = build configuration (Debug, Release)
cmake --build . --config %~1 --target install %cmakeBuildOptions%
exit /b

:OPEN_IN_EDITOR
cmake --open .
exit /b

:RUN_TESTS
rem 1 = build configuration (Debug, Release)
if %CMAKE_COMPILER% == "Ninja Multi-Config" (
	ctest --build-config %~1 %cmakeTestOptions%
) else (
	cmake --build . --config %~1 --target run_tests -- -verbosity:detailed %cmakeTestOptions%
)
exit /b 0

:ende
endlocal