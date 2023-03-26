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

extension Date
{
    func toString(dateFormat format: String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static func fromString(isoDate: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-DDTHH:mm:ss.sssZ"
        return df.date(from: isoDate) ?? Date()
    }
    
    func toMessageFormat() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("HH:mm")
        return df.string(from: self)
    }
    
    static func toMessageFormat(isoDate: String) -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("HH:mm")
        let date = Date.fromString(isoDate: isoDate)
        return df.string(from: date)
    }

}
