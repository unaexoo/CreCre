//
//  GeckoService.swift
//  CreCre
//
//  Created by 윤혜주 on 9/18/25.
//

import Foundation
import CoreData

final class GeckoService {
    static let shared = GeckoService()
    private let coreDataManager: CoreDataManager

    init(manager: CoreDataManager = .shared) {
        self.coreDataManager = manager
    }

    @discardableResult
    func addGecko(
        name: String,
        sex: Sex,
        birthDate: Date,
        adoptedDate: Date?,
        morph: String?,
        imagePath: String?,
        sire: Gecko? = nil,
        dam: Gecko? = nil
    ) -> Gecko {
        let gecko = Gecko(context: coreDataManager.context)
        gecko.id = UUID()
        gecko.name = name
        gecko.sex = sex.rawValue
        gecko.birthDate = birthDate
        gecko.adoptedDate = adoptedDate
        gecko.morph = morph
        gecko.imagePath = imagePath
        gecko.sire = sire
        gecko.dam = dam
        
        coreDataManager.saveContext()
        return gecko
    }

    func updateGecko(
        _ gecko: Gecko,
        name: String,
        sex: Sex,
        birthDate: Date,
        adoptedDate: Date?,
        morph: String?,
        imagePath: String?,
        sire: Gecko? = nil,
        dam: Gecko? = nil
    ){
        gecko.name = name
        gecko.sex = sex.rawValue
        gecko.birthDate = birthDate
        gecko.adoptedDate = adoptedDate
        gecko.morph = morph
        gecko.imagePath = imagePath
        gecko.sire = sire
        gecko.dam = dam
        coreDataManager.saveContext()
    }

    func findGecko(byName name: String) -> Gecko? {
        let request = NSFetchRequest<Gecko>(entityName: "Gecko")
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            return try coreDataManager.context.fetch(request).first
        } catch {
            print("Error finding gecko with name \(name): \(error)")
            return nil
        }
    }

    func fetchAllGeckos(sortedBy key: String = "name", ascending: Bool = true) -> [Gecko] {
        let request = NSFetchRequest<Gecko>(entityName: "Gecko")
        request.sortDescriptors = [NSSortDescriptor(key: key, ascending: ascending)]
        
        do {
            return try coreDataManager.context.fetch(request)
        } catch {
            print("Error fetching geckos: \(error)")
            return []
        }
    }

    func findGecko(by id: UUID) -> Gecko? {
        let request = NSFetchRequest<Gecko>(entityName: "Gecko")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try coreDataManager.context.fetch(request).first
        } catch {
            print("Error finding gecko with id \(id): \(error)")
            return nil
        }
    }

    func updateParents(for gecko: Gecko, sire: Gecko?, dam: Gecko?) {
        gecko.sire = sire
        gecko.dam = dam
        coreDataManager.saveContext()
    }

    func deleteGecko(_ gecko: Gecko) {
        // 관련된 모든 기록(Feed, Clean 등)은 스키마의 Delete Rule(Cascade)에 따라 자동으로 삭제됩니다.
        // 부모/자식 관계(sire, dam, children)는 Nullify로 설정되어 관계만 해제됩니다.
        coreDataManager.delete(gecko)
    }
}
