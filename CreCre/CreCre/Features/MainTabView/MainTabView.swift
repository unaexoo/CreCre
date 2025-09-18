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

    @State private var selectedTab: TabItem = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(TabItem.home.title, systemImage: TabItem.home.iconImage)
                }
                .tag(TabItem.home)

            DiaryView()
                .tabItem {
                    Label(TabItem.diary.title, systemImage:  TabItem.diary.iconImage)
                }
                .tag(TabItem.diary)

            StaticsView()
                .tabItem {
                    Label(TabItem.statics.title, systemImage: TabItem.statics.iconImage)
                }
                .tag(TabItem.statics)

            MapView()
                .tabItem {
                    Label(TabItem.map.title, systemImage: TabItem.map.iconImage)
                }
                .tag(TabItem.map)

            SettingView()
                .tabItem {
                    Label(TabItem.setting.title, systemImage: TabItem.setting.iconImage)
                }
                .tag(TabItem.setting)
        }
    }
}
#Preview {
    MainTabView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
