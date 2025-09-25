//
//  CareLogViewModel.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import Foundation
import SwiftUI
import Combine
import CoreData

@MainActor
class CareLogViewModel: ObservableObject {
    let gecko: Gecko

    var navigationTitle: String {
        return gecko.name ?? "마뱀 기록"
    }

    init(gecko: Gecko) {
         self.gecko = gecko
     }
}
