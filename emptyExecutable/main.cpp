#include "mainwindow.h"

#include <iostream>

int main(int argc, char *argv[])
{
    auto mainWindow = MainWindow::create();
    mainWindow->run();
    return 0;
}
