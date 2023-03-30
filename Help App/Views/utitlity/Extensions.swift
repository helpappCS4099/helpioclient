//
//  Extensions.swift
//  Help App
//
//  Created by Artem Rakhmanov on 22/02/2023.
//

import SwiftUI
import Combine

//https://designcode.io/swiftui-handbook-conditional-modifier
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

//https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift
extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    //st andrews prefix
    func staprefix() -> String {
        return self.components(separatedBy: "@").first ?? "not_st_andrews_email"
    }
}

//https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//https://stackoverflow.com/questions/27182023/getting-the-difference-between-two-dates-months-days-hours-minutes-seconds-in
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension Date
{
    
    func toString(dateFormat format: String = "YYYY-MM-DD'T'HH:mm:ss.sssZ") -> String
    {
        let df = ISO8601DateFormatter()
        return df.string(from: self)
    }
    
    static func fromString(isoDate: String) -> Date {
        let df = ISO8601DateFormatter()
        df.formatOptions = [
            .withFractionalSeconds,
            .withFullDate,
            .withTime, // without time zone
            .withColonSeparatorInTime,
            .withDashSeparatorInDate
        ]
        print("date now", Date())
        print("converted date ", df.date(from: isoDate), isoDate)
        
        return df.date(from: isoDate) ?? Date()
    }
    
    static func toMessageFormat(isoDate: String) -> String {
        let df = ISO8601DateFormatter()
        df.formatOptions = [
            .withFractionalSeconds,
            .withFullDate,
            .withTime, // without time zone
            .withColonSeparatorInTime,
            .withDashSeparatorInDate
        ]
        print("converted date ", df.date(from: isoDate), isoDate)
        let calendar = Calendar.current
        let date = df.date(from: isoDate) ?? Date()
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return String(hours) + ":" + String(minutes)
    }
    
    static func getTimerStartingPoint(isoDate: String) -> (Int, Int) {
        let df = ISO8601DateFormatter()
        df.formatOptions = [
            .withFractionalSeconds,
            .withFullDate,
            .withTime, // without time zone
            .withColonSeparatorInTime,
            .withDashSeparatorInDate
        ]
        let calendar = Calendar.current
        let date = df.date(from: isoDate) ?? Date()
        let now = Date()
        
        let minutes = now.minutes(from: date)
        let seconds = minutes != 0 ? now.seconds(from: date) % minutes : now.seconds(from: date)
        
        return (minutes,seconds)
    }
    
    static func addSecond(toMinutes: Int, toSeconds: Int) -> (Int, Int) {
        if toSeconds == 59 {
            return (toMinutes + 1, 0)
        } else {
            return (toMinutes, toSeconds + 1)
        }
    }

}

extension Int {
    var size: Int {
        self == 0 ? 1 : Int(pow(10.0, floor(log10(abs(Double(self))))))
    }
}

extension NSNotification.Name {
    static let onHelpRequestReceived = Notification.Name("onHelpRequestReceived")
}
