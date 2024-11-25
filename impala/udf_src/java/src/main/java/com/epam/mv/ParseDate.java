package com.epam.mv;

import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.io.Text;

public class ParseDate extends UDF {
    public Text evaluate(Text input) {
        if (input == null) return null;
        String formattedDate = DateUtil.yourDateParsingMethod(input.toString());
        return new Text(formattedDate);
    }
}