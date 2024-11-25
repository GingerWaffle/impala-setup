package com.epam.mv;

import org.apache.hadoop.hive.ql.exec.UDF;
import java.text.NumberFormat;
import java.util.Locale;

public class FormatCurrency extends UDF {
    public String evaluate(Double amount) {
        if (amount == null)
            return null;
        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.US);
        return currencyFormat.format(amount);
    }
}