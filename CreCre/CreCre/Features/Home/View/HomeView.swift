//
//  HomeView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/18/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    @Namespace private var namespace

    /// 주 7일 그리드
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: .largeSpacing) {
                    HStack {
                        Text("CreCre")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.accent)

                        Spacer()

                        NavigationLink {
                            AddGeckoView(type: .add)
                        } label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.accent)
                                .padding(.smallSpacing)
                        }
                        .glassEffect()
                    }
                    .padding(.horizontal, .defaultSpacing)

                    LazyVGrid(columns: columns, spacing: .defaultSpacing) {
                        ForEach(viewModel.weekDays.indices, id: \.self) { index in
                            let date = viewModel.weekDays[index]
                            let isSelected = date.isSameDay(as: viewModel.selectedDate)

                            VStack(spacing: .smallSpacing) {
                                Text(viewModel.weekNames[index])
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.sub)

                                Text("\(date.day)")
                                    .font(.headline)
                                    .fontWeight(isSelected ? .bold : .regular)
                                    .foregroundStyle(isSelected ? .white : .primary.opacity(0.8))
                                    .padding(.smallSpacing)
                                    .background {
                                        if isSelected {
                                            Circle()
                                                .fill(.main)
                                                .matchedGeometryEffect(id: "backgroundCircle", in: namespace)
                                        }
                                    }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    viewModel.selectedDate = date
                                }
                            }
                        }
                    }
                    .padding(.horizontal, .defaultSpacing)

                    ForEach(viewModel.geckos) { gecko in
                        NavigationLink {
                            CareLogView(gecko: gecko)
                        } label: {
                            GeckoCardView(gecko: gecko)
                                .padding(.horizontal, .defaultSpacing)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical)
            }
        }
    }
}

extension Gecko {
    public var lastWeight: Double? {
        guard let weightsSet = self.weights as? Set<Weight>, !weightsSet.isEmpty else {
            return nil
        }

        let sorted = weightsSet.sorted {
            ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast)
        }

        return sorted.first?.grams
    }
}

#Preview {
    let controller = PersistenceController.preview
    let context = controller.container.viewContext
    let sampleImagePath = savePreviewImage(name: "sample-gecko")

    let namuWeights = Weight(context: context)
    namuWeights.id = UUID()
    namuWeights.grams = 33.8
    namuWeights.date = Date()

    let namu = Gecko(context: context)
    namu.id = UUID()
    namu.name = "나무"
    namu.morph = "핀스트라이프 할리퀸"
    namu.imagePath = sampleImagePath
    namu.sex = 1
    namu.addToWeights(namuWeights)

    let ppuri = Gecko(context: context)
    ppuri.id = UUID()
    ppuri.name = "쀼리"
    ppuri.morph = "릴리 화이트"
    ppuri.imagePath = sampleImagePath
    ppuri.sex = 1

    let daechu = Gecko(context: context)
    daechu.id = UUID()
    daechu.name = "대추"
    daechu.morph = "핀스트라이프 할리퀸"
    daechu.imagePath = nil
    daechu.sex = 0

    return HomeView(context: context)
        .environment(\.managedObjectContext, context)
}

fileprivate func savePreviewImage(name: String) -> String? {
    guard let uiImage = UIImage(named: name),
          let data = uiImage.jpegData(compressionQuality: 0.8),
          let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }
    let fileName = "\(UUID().uuidString).jpg"
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    try? data.write(to: fileURL)
    return fileName
}
