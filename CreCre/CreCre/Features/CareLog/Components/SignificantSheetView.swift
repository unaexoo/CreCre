//
//  SignificantSheetView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import SwiftUI
import CoreData

struct SignificantSheetView: View {
    let gecko: Gecko
    @Environment(\.dismiss) private var dismiss

    @State private var date: Date = Date()
    @State private var significant: String = ""

    init(gecko: Gecko) {
        self.gecko = gecko
    }

    var body: some View {
        VStack(spacing: .largeSpacing) {
            Text("특이 사항 추가")
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
                Text("특이 사항")
                    .font(.headline)
                    .foregroundStyle(.accent)

                TextField("ex) 토함, 설사", text: $significant)
                    .padding(.smallSpacing)
                    .overlay(
                        RoundedRectangle(cornerRadius: .smallRadius)
                            .stroke(.secondary.opacity(0.8), lineWidth: 1)
                    )
            }

            SaveButton(title: "저장", color: .accent) {
                RecordService.shared.addObservation(
                    to: gecko,
                    date: date,
                    note: significant
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

    return SignificantSheetView(gecko: sampleGecko)
}
