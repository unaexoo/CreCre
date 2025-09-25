//
//  WeightSheetView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import SwiftUI
import CoreData

struct WeightSheetView: View {
    let gecko: Gecko
    @Environment(\.dismiss) private var dismiss

    @State private var date: Date = Date()
    @State private var weight: String = "2"

    init(gecko: Gecko) {
        self.gecko = gecko
    }

    var body: some View {
        VStack(spacing: .largeSpacing) {
            Text("몸무게 기록 추가")
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
                Text("몸무게")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                TextField("2", text: $weight)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .padding(.smallSpacing)
                    .overlay(
                        RoundedRectangle(cornerRadius: .smallRadius)
                            .stroke(.secondary.opacity(0.8), lineWidth: 1)
                    )
                    .frame(width: 50)

                Text("g")
                    .foregroundStyle(.secondary)
            }
            
            Spacer()

            SaveButton(title: "저장", color: .accent) {
                guard let weightValue = Double(weight) else { return }

                RecordService.shared.addWeight(
                    to: gecko,
                    date: date,
                    grams: weightValue
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

    return WeightSheetView(gecko: sampleGecko)
}
