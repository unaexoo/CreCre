//
//  DateFormatter.swift
//  CreCre
//
//  Created by 윤혜주 on 9/19/25.
//

import Foundation

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }()
}
