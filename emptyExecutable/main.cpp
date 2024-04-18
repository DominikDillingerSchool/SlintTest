#include "mainwindow.h"

#include <iostream>

#if defined(_WIN32) || defined(_WIN64)
#include <windows.h>

#include <psapi.h>
#elif defined(__linux__)
#include <fcntl.h>
#include <fstream>
#include <sstream>
#include <unistd.h>
#elif defined(__EMSCRIPTEN__)
#include <emscripten.h>
#endif

size_t getCurrentMemoryUsage()
{
    size_t memoryUsage = 0;

#if defined(_WIN32) || defined(_WIN64)
    PROCESS_MEMORY_COUNTERS_EX pmc;
    if (GetProcessMemoryInfo(GetCurrentProcess(), (PROCESS_MEMORY_COUNTERS *)&pmc, sizeof(pmc)))
    {
        memoryUsage = pmc.WorkingSetSize;
    }
#elif defined(__linux__)
    std::ifstream memInfo("/proc/self/status");
    if (memInfo.is_open())
    {
        std::string line;
        while (std::getline(memInfo, line))
        {
            if (line.substr(0, 6) == "VmRSS:")
            {
                std::istringstream iss(line.substr(7));
                iss >> memoryUsage;
                memoryUsage *= 1024;
                break;
            }
        }
        memInfo.close();
    }
#elif defined(__EMSCRIPTEN__)
    memoryUsage = emscripten_run_script_int(R"(
    if (typeof window.performance !== 'undefined' && typeof window.performance.memory !== 'undefined') {
        window.performance.memory.usedJSHeapSize;
    }
    )");
#endif

    return memoryUsage;
}

int main(int argc, char *argv[])
{
#ifdef _WIN32
    if (AttachConsole(ATTACH_PARENT_PROCESS))
    {
        freopen("CONOUT$", "w", stdout);
        freopen("CONOUT$", "w", stderr);
    }
#elif __linux__
    if (isatty(STDOUT_FILENO))
    {
        // Open /dev/tty for writing, which represents the terminal
        int tty_fd = open("/dev/tty", O_WRONLY);
        if (tty_fd != -1)
        {
            // Redirect stdout and stderr to /dev/tty
            dup2(tty_fd, STDOUT_FILENO);
            dup2(tty_fd, STDERR_FILENO);
        }
    }
#endif

    auto mainWindow = MainWindow::create();
    mainWindow->on_benchmark([]() { std::cout << "RAM: " << getCurrentMemoryUsage() << " bytes\n"; });
    mainWindow->run();
    return 0;
}
