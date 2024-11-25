#ifndef IMPALA_UDF
#define IMPALA_UDF
#include "impala_udf/udf.h"
#include <cctype>
using namespace impala_udf;

IntVal CountVowels(FunctionContext* context, const StringVal& input) {
    if (input.is_null) return IntVal::null();

    int count = 0;
    for (int i = 0; i < input.len; ++i) {
        uint8_t c = tolower(input.ptr[i]);
        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u') {
            count++;
        }
    }
    return IntVal(count);
}
#endif