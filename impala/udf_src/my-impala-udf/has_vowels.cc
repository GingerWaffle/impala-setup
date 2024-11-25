#ifndef IMPALA_UDF
#define IMPALA_UDF
#include "impala_udf/udf.h"
#include <cctype>
using namespace impala_udf;

BooleanVal HasVowels(FunctionContext* context, const StringVal& input) {
    if (input.is_null) return BooleanVal::null();

    for (int i = 0; i < input.len; ++i) {
        uint8_t c = tolower(input.ptr[i]);
        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u') {
            return BooleanVal(true);
        }
    }
    return BooleanVal(false);
}
#endif