//
//  TabItem.swift
//  CreCre
//
//  Created by 윤혜주 on 9/18/25.
//

import Foundation
import SwiftUI

enum TabItem: CaseIterable {
    case home
    case diary
    case statics
    case map
    case setting

    var isHome: Bool {
         self == .home
    }

    var title: String {
        switch self {
        case .home: return "홈"
        case .diary: return "마뱀일기"
        case .statics: return "체중기록"
        case .map: return "파충류맵"
        case .setting: return "설정"
        }
    }

    var iconImage: String {
        switch self {
        case .home: return "house.fill"
        case .diary: return "calendar"
        case .statics: return "chart.bar"
        case .map: return "map"
        case .setting: return "gearshape.fill"
        }
    }
}
