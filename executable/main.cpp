#include "mainwindow.h"

#include <iostream>

int main(int argc, char *argv[])
{
    std::cout << "Sanity Check.\n";
    auto helloWorld = Demo::create();
    // helloWorld->set_my_label("Hello from C++");
    helloWorld->run();
    std::cout << "Done.\n";
    return 0;
}

/*
#include <iostream>

int main(int argc, char *argv[])
{
    std::cout << "Sanity Check.\n";
}
*/