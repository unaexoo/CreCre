//
//  SettingService.swift
//  CreCre
//
//  Created by 윤혜주 on 9/18/25.
//

import Foundation
import CoreData

final class SettingService {
    static let shared = SettingService()
    private let coreDataManager: CoreDataManager

    init(manager: CoreDataManager = .shared) {
        self.coreDataManager = manager
    }

    // MARK: - Read (with Create if not exists)
    func fetchSettings() -> Setting {
        let request = NSFetchRequest<Setting>(entityName: "Setting")
        
        do {
            // 기존 설정이 있는지 확인
            if let existingSettings = try coreDataManager.context.fetch(request).first {
                return existingSettings
            }
        } catch {
            print("Error fetching settings: \(error)")
        }
        
        // 설정이 없으면 기본값으로 새로 생성
        print("No settings found, creating default settings.")
        let newSettings = Setting(context: coreDataManager.context)
        newSettings.id = UUID()
        newSettings.allowNotification = false
        newSettings.notifyMistEnabled = true
        newSettings.notifyFeedEnabled = true
        newSettings.notifyWeightEnabled = true
        
        coreDataManager.saveContext()
        return newSettings
    }

    // MARK: - Update
    func updateNotificationPermission(allowed: Bool) {
        let settings = fetchSettings()
        settings.allowNotification = allowed
        coreDataManager.saveContext()
    }
    
    func updateNotificationToggles(mist: Bool, feed: Bool, weight: Bool) {
        let settings = fetchSettings()
        settings.notifyMistEnabled = mist
        settings.notifyFeedEnabled = feed
        settings.notifyWeightEnabled = weight
        coreDataManager.saveContext()
    }
}
