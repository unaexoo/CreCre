//
//  SpawningSheetView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import SwiftUI
import CoreData

struct SpawningSheetView: View {
    let gecko: Gecko
    @Environment(\.dismiss) private var dismiss

    @State private var date: Date = Date()
    @State private var eggCount: String = "1"
    init(gecko: Gecko) {
        self.gecko = gecko
    }

    var body: some View {
        VStack(spacing: .largeSpacing) {
            Text("산란 기록 추가")
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
                Text("알 개수")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()

                TextField("", text: $eggCount)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .padding(.smallSpacing)
                    .overlay(
                        RoundedRectangle(cornerRadius: .smallRadius)
                            .stroke(.secondary.opacity(0.8), lineWidth: 1)
                    )
                    .frame(width: 30)

                Text("개")
                    .foregroundStyle(.secondary)
            }

            Spacer()

            SaveButton(title: "저장", color: .accent) {
                guard let eggCountInt = Int16(eggCount), eggCountInt > 0 else {
                    return
                }
                
                RecordService.shared.addEgg(
                    to: gecko,
                    date: date,
                    count: eggCountInt
                )
                dismiss()
            }
        }
        .padding(.defaultSpacing)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let sampleGecko = Gecko(context: context)
    sampleGecko.name = "미리보기 개체"

    return SpawningSheetView(gecko: sampleGecko)
}
