package com.epam.mv;

import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.io.Text;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class DaysBetween extends UDF {
    public Integer evaluate(Text start, Text end) {
        if (start == null || end == null) return null;
        LocalDate startDate = LocalDate.parse(start.toString());
        LocalDate endDate = LocalDate.parse(end.toString());
        return (int) ChronoUnit.DAYS.between(startDate, endDate);
    }
}