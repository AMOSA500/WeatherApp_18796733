//  DateFormatter.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 19/10/2025.
//
import Foundation

/*  class with closures to convert the unix time from json into differents readable date formats
*/
class DateFormatterUtils {

    static let shared: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter
    }()

    static let shortDateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()

    static let timeFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mma"
        return dateFormatter
    }()

    static let customFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()

    static let prettyDateTimeWithZone: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy 'at' HH:mm:ss zzz"
        return dateFormatter
    }()
    
    static let weekdayMonthDay: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        return dateFormatter
    }()

    static func formattedWeekdayMonthDay(from timestamp: TimeInterval, timezoneOffset: Int = 0) -> String {
        let date = Date(
            timeIntervalSince1970: (timestamp) + TimeInterval(
                timezoneOffset
            )
        )
        return weekdayMonthDay.string(from: date)
    }

    static func formattedPrettyDateTimeWithZone(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return prettyDateTimeWithZone.string(from: date)
    }
    
    static func formatedSunriseSunsetTime(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        return timeFormat.string(from: date)
    }

    static func formattedDate(from timestamp: Int, format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    static func formattedCurrentDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }

    static func formattedDateWithStyle(from timestamp: Int, style: DateFormatter.Style) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: date)
    }

    static func formattedDate12Hour(from timestamp: TimeInterval) -> String {
            let date = Date(timeIntervalSince1970: timestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.string(from: date)
    }
    
    static func formattedDate24Hour(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"   // 24-hour format
        return dateFormatter.string(from: date)
    }

    static func formattedDateWithDay(from timestamp: TimeInterval) -> String {
            let dateFormatter = DateFormatter()
//             changed to meet coursework specifications
//            dateFormatter.dateFormat = "h a E" // Format for 12-hour time with AM/PM and abbreviated day of the week
            dateFormatter.dateFormat = "hh a E" //03 PM Wednesday
            let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
            return dateString
    }

    static func formattedDateWithWeekdayAndDay(from timestamp: TimeInterval) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE dd" // Wednesday 12
            return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }


    static func formattedDateTime(from timestamp: TimeInterval) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy 'at' h a"
            return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }

}

