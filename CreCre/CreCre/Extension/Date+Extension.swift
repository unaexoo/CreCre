//
//  Date+Extension.swift
//  CreCre
//
//  Created by 윤혜주 on 9/19/25.
//

import Foundation

extension Date {
    var day: Int {
        Calendar.current.component(.day, from: self)
    }

    func isSameDay(as otherDate: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: otherDate)
    }
}
