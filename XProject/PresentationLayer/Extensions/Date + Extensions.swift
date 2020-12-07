//
//  Date + Extensions.swift
//  XProject
//
//  Created by Максим Локтев on 16.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        let years: Int = self.years(from: date)
        if years > 0 {
            switch years {
            case 1, 21:
                return  "\(years) год назад"
            case 2, 3, 4, 22:
                return  "\(years) года назад"
            default:
                return  "\(years) лет назад"
            }
        }
        
        let months: Int = self.months(from: date)
        if months > 0 {
            switch months {
            case 1:
                return  "\(months) месяц назад"
            case 2, 3, 4:
                return  "\(months) месяца назад"
            default:
                return  "\(months) месяцев назад"
            }
        }
        
        let weeks: Int = self.weeks(from: date)
        if weeks > 0 {
            switch weeks {
            case 1:
                return  "\(weeks) неделю назад"
            case 2, 3, 4:
                return  "\(weeks) недели назад"
            default:
                return  "\(weeks) недель назад"
            }
        }
        
        let days: Int = self.days(from: date)
        if days > 0 {
            switch days {
            case 1, 21, 31:
                return  "\(days) день назад"
            case 2, 3, 4, 22, 23, 24:
                return  "\(days) дня назад"
            default:
                return  "\(days) дней назад"
            }
        }
        
        let hours: Int = self.hours(from: date)
        if hours > 0 {
            switch hours {
            case 1, 21:
                return  "\(hours) час назад"
            case 2, 3, 4, 22, 23, 24:
                return  "\(hours) часа назад"
            default:
                return  "\(hours) часов назад"
            }
        }

        let minutes: Int = self.minutes(from: date)
        if minutes > 0 {
            switch minutes {
            case 1, 21, 31, 41, 51:
                return  "\(minutes) минуту назад"
            case 2, 3, 4, 22, 23, 24, 32, 33, 34, 42, 43, 44, 52, 53, 54:
                return  "\(minutes) минуты назад"
            default:
                return  "\(minutes) минут назад"
            }
        }
        
        return ""
    }
}
