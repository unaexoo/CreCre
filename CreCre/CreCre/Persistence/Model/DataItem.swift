//
//  DataItem.swift
//  CreCre
//
//  Created by 윤혜주 on 9/18/25.
//


import Foundation
import SwiftUI

enum Sex: Int16, CaseIterable {
    case unknown = 0
    case male = 1
    case female = 2

    var description: String {
        switch self {
        case .unknown: return "미구분"
        case .male: return "수컷"
        case .female: return "암컷"
        }
    }

    @ViewBuilder
    var icon: some View {
        switch self {
        case .male:
            Image("male")
                .resizable()
                .frame(width: 20, height: 20)
        case .female:
            Image("female")
                .resizable()
                .frame(width: 20, height: 20)
        case .unknown:
            Image(systemName: "questionmark.circle")
                .resizable()
                .foregroundStyle(.sub)
                .frame(width: 20, height: 20)
        }
    }
}

enum FeedKind: Int16, CaseIterable {
    case superfood = 0
    case cricket = 1
    case mealworm = 2
    case other = 9

    var description: String {
        switch self {
        case .superfood: return "슈퍼푸드"
        case .cricket: return "귀뚜라미"
        case .mealworm: return "밀웜"
        case .other: return "기타"
        }
    }
}

enum FeedSize: Int16, CaseIterable {
    case large = 0
    case medium = 1
    case small = 2

    var description: String {
        switch self {
        case .large: return "대"
        case .medium: return "중"
        case .small: return "소"
        }
    }
}

enum AmountUnit: Int16, CaseIterable {
    case count = 0      // 마리
    case spoon = 1      // 스푼
    case ml = 2         // ml
    case other = 9      // 기타

    var description: String {
        switch self {
        case .count: return "마리"
        case .spoon: return "스푼"
        case .ml: return "ml"
        case .other: return "기타"
        }
    }
}

enum CleanType: Int16, CaseIterable {
    case spot
    case partial
    case full

    var description: String {
        switch self {
        case .spot: return "부분 청소"
        case .partial: return "일부 교체"
        case .full: return "전체 청소"
        }
    }
}

enum MistTimeSlot: Int16, CaseIterable {
    case morning
    case evening

    var description: String {
        switch self {
        case .morning: return "아침"
        case .evening: return "저녁"
        }
    }
}

enum RoutineType: Int16, CaseIterable {
    case mist
    case feed
    case clean
    case weight

    var description: String {
        switch self {
        case .mist: return "분무"
        case .feed: return "급여"
        case .clean: return "청소"
        case .weight: return "무게 측정"
        }
    }
}

enum RepeatMode: Int16, CaseIterable {
    case weekly = 0
    case intervalDays = 1

    var description: String {
        switch self {
        case .weekly: return "주간 반복"
        case .intervalDays: return "간격 반복"
        }
    }
}

// 요일 비트마스크를 다루기 위한 구조체
struct WeekdayMask: OptionSet {
    let rawValue: Int16

    static let sunday    = WeekdayMask(rawValue: 1 << 0)
    static let monday    = WeekdayMask(rawValue: 1 << 1)
    static let tuesday   = WeekdayMask(rawValue: 1 << 2)
    static let wednesday = WeekdayMask(rawValue: 1 << 3)
    static let thursday  = WeekdayMask(rawValue: 1 << 4)
    static let friday    = WeekdayMask(rawValue: 1 << 5)
    static let saturday  = WeekdayMask(rawValue: 1 << 6)

    static let everyday: WeekdayMask = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
}
