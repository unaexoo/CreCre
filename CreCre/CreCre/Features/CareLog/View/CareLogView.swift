//
//  CareLogView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import SwiftUI
import CoreData

struct CareLogView: View {
    @StateObject private var viewModel: CareLogViewModel

    init(gecko: Gecko) {
        _viewModel = StateObject(wrappedValue: CareLogViewModel(gecko: gecko))
    }

    enum CareLogSection: String, CaseIterable, SegmentedControlOption {
        case today = "오늘 케어"
        case log = "기록"
        case routine = "루틴"

        var id: String { self.rawValue }
        var title: String { self.rawValue }
    }

    @State private var selectedSection: CareLogSection = .today
    @State private var isShowingMistSheet: Bool = false
    @State private var isShowingFeedSheet: Bool = false
    @State private var isShowingCleanSheet: Bool = false
    @State private var isShowingWeightSheet: Bool = false
    @State private var isShowingEggSheet: Bool = false
    @State private var isShowingSignifiSheet: Bool = false

    var body: some View {
        NavigationStack{
            VStack(spacing: .largeSpacing) {
                VStack(alignment: .center,spacing: .defaultSpacing) {

                    GeckoImageView(gecko: viewModel.gecko, imageSize: 200)
                    HStack {
                        Text(viewModel.gecko.name ?? "이름 없음")
                            .font(.title)
                            .bold()

                        if let sex = Sex(rawValue: viewModel.gecko.sex) {
                            sex.icon
                        }
                    }
                    HStack {
                        Spacer()
                        Image(systemName: "scalemass")
                            .foregroundStyle(.accent)
                        
                        if let weight = viewModel.gecko.lastWeight {
                            Text(String(format: "%.1fg", weight))
                        }

                        Spacer()
                        Image(systemName: "birthday.cake")
                            .foregroundStyle(.accent)
                        Text(viewModel.gecko.birthDate?.formattedDate() ?? "정보 없음")

                        Spacer()
                        Image(systemName: "heart.text.square")
                            .foregroundStyle(.accent)
                        Text(viewModel.gecko.adoptedDate?.formattedDate() ?? "정보 없음")
                        Spacer()
                    }

                    Text(viewModel.gecko.morph ?? "모프 모름")
                        .font(.headline)
                        .foregroundStyle(.accent)
                }
                
                CustomSegmentedControl(selection: $selectedSection)

                Group {
                    switch selectedSection {
                    case .today:
                        HStack(spacing: .defaultSpacing) {
                            CareCardView(iconName: "drop", title: "분무") {
                                isShowingMistSheet.toggle()
                            }
                            .sheet(isPresented: $isShowingMistSheet) {
                                MistSheetView(gecko: viewModel.gecko)
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.medium])
                            }

                            CareCardView(iconName: "ladybug", title: "피딩") {
                                isShowingFeedSheet.toggle()
                            }
                            .sheet(isPresented: $isShowingFeedSheet) {
                                FeedingSheetView(gecko: viewModel.gecko)
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.large])
                            }

                            CareCardView(iconName: "bubbles.and.sparkles", title: "청소") {
                                isShowingCleanSheet.toggle()
                            }
                            .sheet(isPresented: $isShowingCleanSheet) {
                                CleanSheetView(gecko: viewModel.gecko)
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.medium])
                            }
                        }
                        HStack(spacing: .defaultSpacing) {
                            CareCardView(iconName: "scalemass", title: "몸무게") {
                                isShowingWeightSheet.toggle()
                            }
                            .sheet(isPresented: $isShowingWeightSheet) {
                                WeightSheetView(gecko: viewModel.gecko)
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.medium])
                            }

                            CareCardView(iconName: "capsule", title: "산란") {
                                isShowingEggSheet.toggle()
                            }
                            .sheet(isPresented: $isShowingEggSheet) {
                                SpawningSheetView(gecko: viewModel.gecko)
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.medium])
                            }

                            CareCardView(iconName: "plus.circle", title: "특이 사항") {
                                isShowingSignifiSheet.toggle()
                            }
                            .sheet(isPresented: $isShowingSignifiSheet) {
                                SignificantSheetView(gecko: viewModel.gecko)
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.medium])
                            }
                        }
                    case .log:
                        Text("기록 내용")
                    case .routine:
                        Text("루틴 내용")
                    }
                }
                Spacer()
            }
            .padding(.horizontal, .defaultSpacing)
            .navigationTitle(viewModel.navigationTitle)
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        AddGeckoView(type: .edit)
                    } label: {
                       Text("편집")
                            .foregroundStyle(.accent)
                    }
                }
            }
        }
    }
}

struct CareCardView: View {
    let iconName: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: .smallSpacing) {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.accent)

                Text(title)
                    .font(.headline)
                    .bold()
                    .foregroundStyle(.accent)
            }
            .padding(.defaultSpacing)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: .defaultRadius))
            .overlay(
                RoundedRectangle(cornerRadius: .defaultRadius)
                    .stroke(.accent, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct InfoRow: View {
    let title: String
    let content: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.accent)
                .frame(width: 50, alignment: .leading)

            Text(content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}


#Preview {
    let controller = PersistenceController.preview
    let context = controller.container.viewContext

    let namuWeights = Weight(context: context)
    namuWeights.id = UUID()
    namuWeights.grams = 33.8
    namuWeights.date = Date()

    let namu = Gecko(context: context)
    namu.id = UUID()
    namu.name = "나무"
    namu.morph = "핀스트라이프 할리퀸"
    namu.imagePath = nil
    namu.sex = 1
    namu.addToWeights(namuWeights)

    return CareLogView(gecko: namu)
        .environment(\.managedObjectContext, context)
}
