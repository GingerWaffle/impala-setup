package com.epam.mv;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateUtil {

    public static String yourDateParsingMethod(String inputDate) {
        // Define the input date format
        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        
        // Parse the input string to LocalDate
        LocalDate date = LocalDate.parse(inputDate, inputFormatter);
        
        // Define the output date format
        DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        
        // Convert LocalDate to LocalDateTime at the start of the day (midnight)
        LocalDateTime dateTime = date.atStartOfDay();
        
        // Format the LocalDateTime to string
        return dateTime.format(outputFormatter);
    }
}