//
//  Date.swift
//  ThymeBar
//
//  Created by Ian Ruh on 1/7/19.
//  Copyright © 2019 Ian Ruh. All rights reserved.
//

import Foundation

class DateCust {
    
    static var today: String {
        let date = Date()
        return parseDate(date: date)
    }
    
    static var yesterday: String {
        let date = Date.yesterday
        return parseDate(date: date)
    }
    
    static func parseDate(date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        var monthString = String(month)
        var dayString = String(day)
        if(month < 10) {
            monthString = "0" + String(month)
        }
        if(day < 10) {
            dayString = "0" + String(day)
        }
        
        return String(String(year) + "-" + monthString + "-" + dayString + ".json")
    }
}

extension Date {
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date().noon)!
    }
    static var today: Date {
        return Calendar.current.date(byAdding: .day, value: 0, to: Date().noon)!
    }
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().noon)!
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension Date {
    //0-6, Sunday-Saturday
    func dayNumberOfWeek() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday! - 1
    }
}
