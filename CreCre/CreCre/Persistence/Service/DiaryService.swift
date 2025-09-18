//
//  DiaryService.swift
//  CreCre
//
//  Created by 윤혜주 on 9/18/25.
//

import Foundation
import CoreData

final class DiaryService {
    static let shared = DiaryService()
    private let coreDataManager: CoreDataManager

    init(manager: CoreDataManager = .shared) {
        self.coreDataManager = manager
    }

    @discardableResult
    func addDiary(
        to gecko: Gecko,
        date: Date,
        title: String?,
        content: String?,
        imagePath: String?
    ) -> Diary {
        let diary = Diary(context: coreDataManager.context)
        diary.id = UUID()
        diary.date = date
        diary.title = title
        diary.content = content
        diary.imagePath = imagePath
        diary.gecko = gecko
        
        coreDataManager.saveContext()
        return diary
    }

    func fetchDiaries(for gecko: Gecko) -> [Diary] {
        let request = NSFetchRequest<Diary>(entityName: "Diary")
        request.predicate = NSPredicate(format: "gecko == %@", gecko)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try coreDataManager.context.fetch(request)
        } catch {
            print("Error fetching diaries: \(error)")
            return []
        }
    }

    func deleteDiary(_ diary: Diary) {
        coreDataManager.delete(diary)
    }
}
