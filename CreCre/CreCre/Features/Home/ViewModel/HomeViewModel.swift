//
//  HomeViewModel.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//


import SwiftUI
import CoreData
import Combine


class HomeViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

    // MARK: - Published Properties
    /// View에서 관찰할 프로퍼티들을 @Published로 선언합니다.
    @Published var selectedDate: Date = Date() {
        didSet {
            updateWeekDays()
        }
    }
    @Published var weekDays: [Date] = []
    @Published var geckos: [Gecko] = []
    
    /// 요일 이름을 저장하는 프로퍼티
    let weekNames = ["일", "월", "화", "수", "목", "금", "토"]

    /// Core Data 변경을 감지하는 컨트롤러
    private var fetchedResultsController: NSFetchedResultsController<Gecko>
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        
        // 1. Core Data에서 Gecko 데이터를 가져올 요청(request)을 설정
        let fetchRequest: NSFetchRequest<Gecko> = Gecko.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Gecko.name, ascending: true)]
        
        // 2. NSFetchedResultsController를 초기화
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
            
        super.init()

        // 3. 컨트롤러의 delegate를 self로 설정하여 데이터 변경 알림
        self.fetchedResultsController.delegate = self
        
        // 4. 초기 데이터
        performFetch()
        
        // 5. 초기 주간 날짜를 설정
        updateWeekDays()
    }

    /// Core Data에서 데이터를 가져와 geckos 프로퍼티를 업데이트
    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
            self.geckos = fetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Error: 데이터를 가져오는 데 실패했습니다: \(error)")
        }
    }
    
    /// Core Data의 내용이 변경될 때마다 NSFetchedResultsControllerDelegate에 의해 자동 호출되는 메서드
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        // 데이터가 변경되면 geckos 배열을 최신 상태로 업데이트하여 View에 반영
        self.geckos = controller.fetchedObjects as? [Gecko] ?? []
    }

    /// 선택된 날짜가 포함된 주의 모든 날짜(일~토)를 계산하여 weekDays 프로퍼티를 업데이트
    private func updateWeekDays() {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)) else {
            self.weekDays = []
            return
        }
        self.weekDays = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
}
