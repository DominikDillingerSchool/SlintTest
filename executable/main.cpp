#include "benchmark.h"

#include "mainwindow.h"

#include <cstring>

#ifdef _WIN32
#include <windows.h>
#elif __linux__
#include <fcntl.h>
#include <iostream>
#include <unistd.h>
#endif

const char *trim(const char *str)
{
    if (str == nullptr)
    {
        return nullptr;
    }

    // Find the first non-whitespace character
    while (std::isspace(*str))
    {
        str++;
    }

    // If the string is all whitespace, return an empty string
    if (*str == '\0')
    {
        return "";
    }

    // Find the last non-whitespace character
    const char *end = str + std::strlen(str) - 1;
    while (end > str && std::isspace(*end))
    {
        end--;
    }

    // Create a new string with the trimmed content
    char *trimmedStr = new char[end - str + 2];
    std::memcpy(trimmedStr, str, end - str + 1);
    trimmedStr[end - str + 1] = '\0';

    return trimmedStr;
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

    long lastModelId = 0;
    auto model = std::make_shared<slint::VectorModel<Entry>>(std::vector<Entry>());
    mainWindow->set_model(model);

    mainWindow->on_modelAppend([&model, &lastModelId](const slint::SharedString &nextEntryText) {
        // Check if input string valid
        const char *trimmedEntryText = trim(nextEntryText.data());
        if (trimmedEntryText == nullptr || *trimmedEntryText == '\0')
        {
            return;
        }

        // Add new entry to model
        lastModelId++;
        model->push_back({lastModelId, trimmedEntryText});
    });

    mainWindow->on_modelDeleteEntry([&model](const int idToDelete) {
        // Find matching ids and delete
        for (int index = 0; index < model->row_count(); index++)
        {
            if (model->row_data(index)->id == idToDelete)
            {
                model->erase(index);
                index--;
            }
        }
    });

    mainWindow->on_benchmark([&model]() { return Benchmark::benchmarks(model); });

    mainWindow->run();

    return 0;
}
