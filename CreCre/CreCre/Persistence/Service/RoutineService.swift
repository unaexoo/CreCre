//
//  RoutineService.swift
//  CreCre
//
//  Created by 윤혜주 on 9/18/25.
//

import Foundation
import CoreData

final class RoutineService {
    static let shared = RoutineService()
    private let coreDataManager: CoreDataManager

    init(manager: CoreDataManager = .shared) {
        self.coreDataManager = manager
    }

    // MARK: - Create
    @discardableResult
    func addRoutine(
        for gecko: Gecko,
        type: RoutineType,
        hour: Int16,
        minute: Int16,
        repeatMode: RepeatMode,
        weekdayMask: WeekdayMask? = nil,
        intervalDays: Int16? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        note: String? = nil,
        enabled: Bool = true
    ) -> Routine {
        let routine = Routine(context: coreDataManager.context)
        routine.id = UUID()
        routine.type = type.rawValue
        routine.hour = hour
        routine.minute = minute
        routine.repeatMode = repeatMode.rawValue
        
        if repeatMode == .weekly {
            routine.weekdayMask = weekdayMask?.rawValue ?? 0
        } else { // .intervalDays
            routine.intervalDays = intervalDays ?? 1
            routine.startDate = startDate ?? Date()
        }
        
        routine.endDate = endDate
        routine.enabled = enabled
        routine.gecko = gecko
        
        coreDataManager.saveContext()
        return routine
    }

    func fetchRoutines(for gecko: Gecko, onlyEnabled: Bool = false) -> [Routine] {
        let request = NSFetchRequest<Routine>(entityName: "Routine")
        var predicates = [NSPredicate(format: "gecko == %@", gecko)]
        
        if onlyEnabled {
            predicates.append(NSPredicate(format: "enabled == %@", NSNumber(value: true)))
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: "hour", ascending: true), NSSortDescriptor(key: "minute", ascending: true)]
        
        do {
            return try coreDataManager.context.fetch(request)
        } catch {
            print("Error fetching routines: \(error)")
            return []
        }
    }

    func updateRoutineCompletion(routine: Routine, isCompleted: Bool) {
        routine.lastCompletedAt = isCompleted ? Date() : nil
        coreDataManager.saveContext()
    }
    
    func toggleRoutine(routine: Routine, isEnabled: Bool) {
        routine.enabled = isEnabled
        coreDataManager.saveContext()
    }

    func deleteRoutine(_ routine: Routine) {
        coreDataManager.delete(routine)
    }
}
