#include "impala_udf/udf.h"

using namespace impala_udf;

void SumOfSquaresInit(FunctionContext* context, BigIntVal* val) {
    val->is_null = false;
    val->val = 0;
}

void SumOfSquaresUpdate(FunctionContext* context, const BigIntVal& input, BigIntVal* val) {
    if (input.is_null) return;
    val->val += input.val * input.val;
}

void SumOfSquaresMerge(FunctionContext* context, const BigIntVal& src, BigIntVal* dst) {
    dst->val += src.val;
}

BigIntVal SumOfSquaresFinalize(FunctionContext* context, const BigIntVal& val) {
    return val;
}