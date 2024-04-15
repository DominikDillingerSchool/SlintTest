#pragma once

#include <memory>
#include <slint.h>
#include <string>

class Entry;

class Benchmark
{
  public:
    static std::string benchmarks(std::shared_ptr<slint::VectorModel<Entry>> &model);

  private:
    static size_t getCurrentMemoryUsage();
    static std::string benchmark(std::shared_ptr<slint::VectorModel<Entry>> &model, const unsigned int elementCount);
};