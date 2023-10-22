#include "jlcxx/jlcxx.hpp"
#include <string>

std::string greet()
{
   return "hello, world";
}



JLCXX_MODULE define_julia_module(jlcxx::Module& mod)
{
  mod.method("greet", &greet);
}
