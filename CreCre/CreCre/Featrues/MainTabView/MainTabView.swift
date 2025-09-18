//
//  ContentView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/17/25.
//

import SwiftUI
import CoreData

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        

    }
}
#Preview {
    MainTabView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
