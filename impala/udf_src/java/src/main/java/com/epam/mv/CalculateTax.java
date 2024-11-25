package com.epam.mv;

import org.apache.hadoop.hive.ql.exec.UDF;

public class CalculateTax extends UDF {
    public Double evaluate(Double amount) {
        if (amount == null) return null;
        return amount * 0.15;  // Assuming a fixed tax rate of 15%
    }
}
