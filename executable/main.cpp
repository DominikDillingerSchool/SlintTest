#include "mainwindow.h"

#include <iostream>

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
    auto mainWindow = MainWindow::create();

    mainWindow->on_modelAppend([mainWindowWeakHandle = slint::ComponentWeakHandle(mainWindow)] {
        auto mainWindow = *mainWindowWeakHandle.lock();

        // Check if input string valid
        const auto nextEntryText = mainWindow->get_textValue();
        const char *trimmedEntryText = trim(nextEntryText.data());
        if (trimmedEntryText == nullptr || *trimmedEntryText == '\0')
        {
            return;
        }
        const int currentId = mainWindow->get_listViewIdCount();
        const Entry nextEntry = {currentId, nextEntryText};
        mainWindow->set_listViewIdCount(currentId + 1);

        // Copy currentModel and append nextEntry
        const auto currentModel = mainWindow->get_model();
        std::vector<Entry> newModel;
        for (long i = 0; i < currentModel->row_count(); i++)
        {
            newModel.push_back(*currentModel->row_data(i));
        }
        newModel.push_back(nextEntry);

        mainWindow->set_model(std::make_shared<slint::VectorModel<Entry>>(newModel));
    });

    mainWindow->on_modelDeleteEntry([mainWindowWeakHandle = slint::ComponentWeakHandle(mainWindow)](int idToDelete) {
        auto mainWindow = *mainWindowWeakHandle.lock();

        // Find id and delete
        const auto currentModel = mainWindow->get_model();
        std::vector<Entry> newModel;
        for (long i = 0; i < currentModel->row_count(); i++)
        {
            const Entry entry = *currentModel->row_data(i);
            if (entry.id == idToDelete)
            {
                continue;
            }

            newModel.push_back(*currentModel->row_data(i));
        }

        mainWindow->set_model(std::make_shared<slint::VectorModel<Entry>>(newModel));
    });

    mainWindow->run();
    return 0;
}
