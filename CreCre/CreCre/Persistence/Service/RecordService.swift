//
//  RecordService.swift
//  CreCre
//
//  Created by 윤혜주 on 9/18/25.
//

import Foundation
import CoreData

final class RecordService {
    static let shared = RecordService()
    private let coreDataManager: CoreDataManager

    init(manager: CoreDataManager = .shared) {
        self.coreDataManager = manager
    }

    @discardableResult
    func addFeed(
        to gecko: Gecko,
        date: Date,
        kind: FeedKind,
        size: FeedSize?,
        amountValue: Double?,
        amountUnit: AmountUnit?,
        ateWell: Bool,
        note: String?
    ) -> Feed {
        let feed = Feed(context: coreDataManager.context)
        feed.id = UUID()
        feed.date = date
        feed.kind = kind.rawValue

        if let size = size { feed.size = size.rawValue }
        if let amountValue = amountValue { feed.amountValue = amountValue }
        if let amountUnit = amountUnit { feed.amountUnit = amountUnit.rawValue }

        feed.ateWell = ateWell
        feed.note = note
        feed.gecko = gecko
        
        coreDataManager.saveContext()
        return feed
    }

    @discardableResult
    func addClean(to gecko: Gecko, date: Date, type: CleanType) -> Clean {
        let clean = Clean(context: coreDataManager.context)
        clean.id = UUID()
        clean.date = date
        clean.cleanType = type.rawValue
        clean.gecko = gecko
        
        coreDataManager.saveContext()
        return clean
    }

    @discardableResult
    func addMist(to gecko: Gecko, date: Date, timeSlot: MistTimeSlot?, count: Int16) -> Mist {
        let mist = Mist(context: coreDataManager.context)
        mist.id = UUID()
        mist.date = date
        
        if let timeSlot = timeSlot { mist.timeSlot = timeSlot.rawValue }
        mist.count = count
        mist.gecko = gecko
        
        coreDataManager.saveContext()
        return mist
    }

    @discardableResult
    func addWeight(to gecko: Gecko, date: Date, grams: Double) -> Weight {
        let weight = Weight(context: coreDataManager.context)
        weight.id = UUID()
        weight.date = date
        weight.grams = grams
        weight.gecko = gecko
        
        coreDataManager.saveContext()
        return weight
    }

    @discardableResult
    func addEgg(to gecko: Gecko, date: Date, count: Int16) -> Egg {
        let egg = Egg(context: coreDataManager.context)
        egg.id = UUID()
        egg.date = date
        egg.countEgg = count
        egg.gecko = gecko

        coreDataManager.saveContext()
        return egg
    }

    @discardableResult
    func addObservation(to gecko: Gecko, date: Date, note: String) -> Observation {
        let observation = Observation(context: coreDataManager.context)
        observation.id = UUID()
        observation.date = date
        observation.note = note
        observation.gecko = gecko
        
        coreDataManager.saveContext()
        return observation
    }

    // 모든 기록 타입이 NSManagedObject를 상속하므로 제네릭을 사용하여 삭제 메서드를 하나로 통일
    func deleteRecord<T: NSManagedObject>(_ record: T) {
        coreDataManager.delete(record)
    }
    
    // MARK: - Generic Fetch
    // 개체에 종속된 기록들을 날짜순으로 정렬하여 가져옵니다.
    func fetchRecords<T: NSManagedObject>(for gecko: Gecko, entityName: String) -> [T] {
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = NSPredicate(format: "gecko == %@", gecko)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try coreDataManager.context.fetch(request)
        } catch {
            print("Error fetching \(entityName): \(error)")
            return []
        }
    }
}
