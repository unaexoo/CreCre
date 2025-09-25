//
//  FeedingSheetView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import SwiftUI
import CoreData


struct FeedingSheetView: View {
    let gecko: Gecko
    @Environment(\.dismiss) private var dismiss

    @State private var date: Date = Date()
    @State private var selectedKind: FeedKind = .superfood
    @State private var selectedSize: FeedSize = .large
    @State private var amount: String = "1"

    @State private var selectedUnit: AmountUnit = .ml
    @State private var customUnitString: String = ""
    @State private var ateWell: Bool? = nil
    @State private var memo: String = ""

    init(gecko: Gecko) {
        self.gecko = gecko
    }

    var body: some View {
        VStack(spacing: .largeSpacing) {
            Text("피딩 기록 추가")
                .font(.title)
                .foregroundStyle(.accent)
                .bold()

            HStack {
                Text("날짜")
                    .font(.headline)
                    .foregroundStyle(.accent)
                Spacer()
                DateFieldView(date: $date)
            }

            VStack(alignment: .leading, spacing: .defaultSpacing) {
                Text("먹이 종류")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: .defaultSpacing) {
                    ForEach(FeedKind.allCases, id: \.self) { kind in
                        ChipButton(title: kind.description, isSelected: selectedKind == kind) {
                            selectedKind = kind
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: .defaultSpacing) {
                Text("먹이 사이즈")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: .defaultSpacing) {
                    ForEach(FeedSize.allCases, id: \.self) { size in
                        ChipButton(title: size.description, isSelected: selectedSize == size) {
                            selectedSize = size
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: .defaultSpacing) {
                Text("양")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: .defaultSpacing) {
                    TextField("1", text: $amount)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .padding(.smallSpacing)
                        .overlay(
                            RoundedRectangle(cornerRadius: .smallRadius)
                                .stroke(.secondary.opacity(0.8), lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)

                    switch selectedKind {
                    case .superfood:
                        ChipButton(
                            title: AmountUnit.ml.description,
                            isSelected: selectedUnit == .ml
                        ) {
                            selectedUnit = .ml
                        }
                        ChipButton(
                            title: AmountUnit.spoon.description,
                            isSelected: selectedUnit == .spoon
                        ) {
                            selectedUnit = .spoon
                        }

                    case .cricket, .mealworm:
                        Text(AmountUnit.count.description)
                            .font(.body)
                            .foregroundStyle(.secondary)

                    case .other:
                        TextField("단위", text: $customUnitString)
                            .keyboardType(.numberPad)
                            .padding(.smallSpacing)
                            .overlay(
                                RoundedRectangle(cornerRadius: .smallRadius)
                                    .stroke(.secondary.opacity(0.8), lineWidth: 1)
                            )
                            .frame(width: 50)
                    }
                }
            }

            HStack {
                Text("잘 먹었나요?")
                    .font(.headline)
                    .foregroundStyle(.accent)

                Spacer()

                let isYesSelected = Binding<Bool>(
                    get: { self.ateWell == true },
                    set: { newValue in
                        self.ateWell = newValue ? true : nil
                    }
                )

                let isNoSelected = Binding<Bool>(
                    get: { self.ateWell == false },
                    set: { newValue in
                        self.ateWell = newValue ? false : nil
                    }
                )

                CheckButton(title: "예", isSelected: isYesSelected)
                CheckButton(title: "아니오", isSelected: isNoSelected)
            }

            VStack(alignment: .leading, spacing: .defaultSpacing) {
                Text("메모")
                    .font(.headline)
                    .foregroundStyle(.accent)

                TextField("ex) 평소보다 덜 먹음", text: $memo)
                    .multilineTextAlignment(.leading)
                    .padding(.smallSpacing)
                    .overlay(
                        RoundedRectangle(cornerRadius: .smallRadius)
                            .stroke(.secondary.opacity(0.8), lineWidth: 1)
                    )
            }
            
            Spacer()

            SaveButton(title: "저장", color: .accent) {
                let amountValue = Double(amount)
                let didEatWell = ateWell ?? false

                RecordService.shared.addFeed(
                    to: gecko,
                    date: date,
                    kind: selectedKind,
                    size: selectedSize,
                    amountValue: amountValue,
                    amountUnit: selectedUnit,
                    ateWell: didEatWell,
                    note: memo
                )
                dismiss()
            }
        }
        .padding(.defaultSpacing)
        .onChange(of: selectedKind) {
            switch selectedKind {
            case .superfood:
                selectedUnit = .ml
            case .cricket, .mealworm:
                selectedUnit = .count
            case .other:
                selectedUnit = .other
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let sampleGecko = Gecko(context: context)
    sampleGecko.name = "미리보기 개체"

    return FeedingSheetView(gecko: sampleGecko)
}
