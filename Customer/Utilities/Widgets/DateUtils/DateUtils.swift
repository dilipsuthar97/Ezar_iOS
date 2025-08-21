//
//  DateUtils.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import UIKit

struct DATE_FORMAT {
    static let serverTime = "yyyy-MM-dd HH:mm:ss"
    static let server = "yyyy-MM-dd"
    static let delivery = "dd MMM yyyy"
    static let order = "dd MMM hh:mm a"
    static let event = "dd MMM yyyy hh:mm a"
    static let palce = "dd MMMM"
    static let pickup_palce = "dd MMMM yyyy"
    static let days = "dd-MM-yyyy"
    static let review = "dd-mm-yyyy hh:mm:ss a"
}

class DateUtils: NSObject {
    class func formateDate(date: String,
                           fromFormate: String,
                           toFormate: String) -> String? {
        let df = DateFormatter()
        df.dateFormat = fromFormate
        let convertedDate = df.date(from: date)

        let df1 = DateFormatter()
        df1.dateFormat = toFormate
        df1.amSymbol = "AM"
        df1.pmSymbol = "PM"
        df1.locale = Locale.current
        df1.timeZone = TimeZone.current

        if let date = convertedDate {
            let convertedDate = df1.string(from: date)
            return convertedDate
        }
        return nil
    }

    class func timeAgoSinceDay(_ date: Date) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.hour, .day, .month, .year]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags,
                                                 from: earliest,
                                                 to: latest)

        if components.year! > 1 {
            return "\(components.year!) years"
        } else if components.year! == 1 {
            return "1 year"
        } else if components.month! > 1 {
            return "\(components.month!) months"
        } else if components.month! == 1 {
            return "1 month"
        } else {
            if components.day! == 0 {
                return "Today"
            } else if components.day! == 1 {
                return "1 day "
            } else {
                return "\(components.day!) days"
            }
        }
    }

    class func isDateInThisWeek(_ date: Date) -> Bool {
        let gregorian = Calendar(identifier: .gregorian)
        let todaysComponents = gregorian.dateComponents([.weekOfYear],
                                                        from: Date())
        let todaysWeek: Int? = todaysComponents.weekOfYear
        let otherComponents = gregorian.dateComponents([.weekOfYear],
                                                       from: date)
        let datesWeek: Int? = otherComponents.weekOfYear

        if todaysWeek == datesWeek {
            return true
        }
        return false
    }

    class func isDateInThisMonth(_ date: Date) -> Bool {
        let gregorian = Calendar(identifier: .gregorian)
        let todaysComponents = gregorian.dateComponents([.month],
                                                        from: Date())
        let todaysWeek = todaysComponents.month
        let otherComponents = gregorian.dateComponents([.month],
                                                       from: date)
        let datesWeek = otherComponents.month

        if todaysWeek == datesWeek {
            return true
        }
        return false
    }

    class func secondsToHoursMinutes(seconds: Int) -> (String) {
        return "Today " + String(format: "%d:%d",
                                 seconds / 3600,
                                 (seconds % 3600) / 60)
    }

    class func getDay(fromDate date: Date?) -> String {
        if let date = date {
            let df = DateFormatter()
            df.dateFormat = "EEE"
            df.locale = Locale.current
            return df.string(from: date)
        }
        return ""
    }

    class func getDateAndMonth(fromDate date: Date?) -> String {
        if let date = date {
            let df = DateFormatter()
            df.dateFormat = "MMM - dd"
            df.locale = Locale.current
            return df.string(from: date)
        }
        return ""
    }

    class func getMonth(fromDate date: Date?) -> String {
        if let date = date {
            let df = DateFormatter()
            df.dateFormat = "MMMM"
            df.locale = Locale.current

            return df.string(from: date)
        }
        return "NA"
    }

    class func getUTCDateFrom(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let defaultTimeZoneStr = formatter.string(from: date)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: defaultTimeZoneStr)!
    }

    class func getDateFromString(stringDate: String,
                                 formate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = formate
        let date = dateFormatter.date(from: stringDate)
        return date
    }

    class func getStringFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DATE_FORMAT.serverTime
        let now = formatter.string(from: date)
        return now
    }

    class func getLocalFrom(UTC date: String) -> String {
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "UTC")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss a"
        let utcDate = df.date(from: date)

        let df1 = DateFormatter()
        df1.dateFormat = "yyyy-MM-dd HH:mm:ss a"
        df1.timeZone = TimeZone.current
        if let utcDate = utcDate {
            let localDate = df1.string(from: utcDate)
            return localDate
        }
        return ""
    }

    static func getDates11(date: Date = Date(), _ forLastNDays: Int) -> [String] {
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: date)
        var arrDates = [String]()

        for _ in 1 ... forLastNDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: 1, to: date)!

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DATE_FORMAT.delivery
            let dateString = dateFormatter.string(from: date)

            let day = DateUtils.formateDate(date: dateString,
                                            fromFormate: DATE_FORMAT.delivery,
                                            toFormate: "d") ?? ""
            let month = DateUtils.formateDate(date: dateString,
                                              fromFormate: DATE_FORMAT.delivery,
                                              toFormate: "MMM") ?? ""
            let finalDateString = "\(DateUtils.getDay(fromDate: date)), " + "\(day) " + "\(month)"

            arrDates.append(finalDateString)
        }
        return arrDates
    }

    static func getDates(date: Date = Date(), _ forLastNDays: Int) -> [String] {
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: date)
        var arrDates = [String]()

        for _ in 1 ... forLastNDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day,
                            value: 1,
                            to: date)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DATE_FORMAT.delivery
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        return arrDates
    }

    static func minutesToHoursAndMinutes(_ minutes: Int) -> String {
        let hrs = minutes / 60
        let mints = minutes % 60
        if hrs == 0 {
            return "\(mints) mins"
        }

        if hrs == 1 {
            return "\(hrs) hr \(mints) mins"
        }

        return "\(hrs) hrs \(mints) mins"
    }
}

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var third_DayFormToday: Date {
        return Calendar.current.date(byAdding: .day, value: 3, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }

    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var minutesToMidnight: Int {
        let calendar = NSCalendar.current
        guard let noonishTomorow = calendar.date(bySetting: Calendar.Component.hour,
                                                 value: 12,
                                                 of: Date()) else {
            return 0
        }

        let midnight = calendar.startOfDay(for: noonishTomorow)
        let components = calendar.dateComponents([.hour, .minute], from: Date(), to: midnight)
        var hoursUntilMidnight = components.hour ?? 0
        var minutesLeftInHour = components.minute ?? 0
        if minutesLeftInHour < 0 {
            minutesLeftInHour += 60
            hoursUntilMidnight -= 1
        }
        if hoursUntilMidnight < 0 {
            hoursUntilMidnight += 24
        }
        print("\(hoursUntilMidnight) hours and \(minutesLeftInHour) minutes till midnight")
        return hoursUntilMidnight * 60 + minutesLeftInHour + 1 + (60 * 8) // Moring
    }
}
