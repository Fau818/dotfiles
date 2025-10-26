#ifndef _GLIBCXX_NO_ASSERT
#include <cassert>
#endif
#include <algorithm>
#include <array>
// #include <atomic>
#include <bitset>
#include <ccomplex>
#include <cctype>
// #include <cerrno>
// #include <cfenv>
#include <cfloat>
// #include <chrono>
// #include <cinttypes>
// #include <ciso646>
#include <climits>
// #include <clocale>
#include <cmath>
#include <complex>
// #include <condition_variable>
// #include <csetjmp>
// #include <csignal>
// #include <cstdalign>
// #include <cstdarg>
// #include <cstdbool>
// #include <cstddef>
// #include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
// #include <ctgmath>
#include <ctime>
// #include <cwchar>
// #include <cwctype>
#include <deque>
// #include <exception>
// #include <forward_list>
#include <fstream>
// #include <functional>
// #include <future>
// #include <initializer_list>
#include <iomanip>
// #include <ios>
// #include <iosfwd>
#include <iostream>
#include <istream>
#include <iterator>
#include <limits>
#include <list>
// #include <locale>
#include <map>
// #include <memory>
// #include <mutex>
#include <new>
#include <numeric>
#include <ostream>
#include <queue>
#include <random>
// #include <ratio>
// #include <regex>
// #include <scoped_allocator>
#include <set>
#include <sstream>
#include <stack>
// #include <stdexcept>
// #include <streambuf>
#include <string>
// #include <system_error>
// #include <thread>
#include <tuple>
// #include <type_traits>
// #include <typeindex>
// #include <typeinfo>
#include <unordered_map>
#include <unordered_set>
// #include <utility>
// #include <valarray>
#include <vector>


#define Fau_Begin freopen("../TEXT/in.txt", "r", stdin); freopen("../TEXT/out.txt", "w", stdout);
#define Fau_End fclose(stdout); system("../compare_Fau");


namespace { //DEBUG
#define debug(a...) std::cout << "(" << (#a) << ")" << " = (", Fau_DEBUG(a)
	template<typename T>
	void Fau_DEBUG(T value) { std::cout << value << ")" << std::endl; }
	template<typename T1, typename... T2>
	void Fau_DEBUG(T1 now, T2... other) { std::cout << now << ", ", Fau_DEBUG(other...); }
}
