//
//  MistSheetView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import SwiftUI
import CoreData

struct MistSheetView: View {
    let gecko: Gecko
    @Environment(\.dismiss) private var dismiss

    @State private var date: Date = Date()
    @State private var isMorningSelected: Bool = false
    @State private var isEveningSelected: Bool = false
    @State private var count: String = "1"

    init(gecko: Gecko) {
        self.gecko = gecko
    }

    var body: some View {
        VStack(spacing: .largeSpacing) {
            Text("분무 기록 추가")
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

            HStack {
                Text("시간대")
                    .font(.headline)
                    .foregroundStyle(.accent)
                Spacer()

                CheckButton(title: "아침", isSelected: $isMorningSelected)

                CheckButton(title: "저녁", isSelected: $isEveningSelected)
            }

            HStack {
                Text("횟수")
                    .font(.headline)
                    .foregroundStyle(.accent)
                Spacer()

                TextField("1", text: $count)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .padding(.smallSpacing)
                    .overlay(
                        RoundedRectangle(cornerRadius: .smallRadius)
                            .stroke(.secondary.opacity(0.8), lineWidth: 1)
                    )
                    .frame(width: 50)

                Text("회")
                    .foregroundStyle(.secondary)
            }

            Spacer()

            SaveButton(title: "저장", color: .accent) {
                guard let countInt = Int16(count), countInt > 0 else { return }

                if isMorningSelected {
                    RecordService.shared.addMist(
                        to: gecko,
                        date: date,
                        timeSlot: .morning,
                        count: countInt
                    )
                }

                if isEveningSelected {
                    RecordService.shared.addMist(
                        to: gecko,
                        date: date,
                        timeSlot: .evening,
                        count: countInt
                    )
                }

                if isMorningSelected || isEveningSelected {
                    dismiss()
                }
            }
        }
        .padding(.defaultSpacing)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let sampleGecko = Gecko(context: context)
    sampleGecko.name = "미리보기 개체"

    return MistSheetView(gecko: sampleGecko)
}
